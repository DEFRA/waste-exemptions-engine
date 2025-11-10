# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operation Sites Forms" do
    let(:transient_registration) { create(:back_office_edit_registration, workflow_state: "operation_sites_form", is_multisite_registration: true) }

    let!(:site_address) do
      create(
        :transient_address,
        :site_using_grid_reference,
        transient_registration: transient_registration,
        site_suffix: "00001",
        description: "Existing site description"
      )
    end

    describe "GET operation_sites_form" do
      let(:request_path) { "/waste_exemptions_engine/#{transient_registration.token}/operation_sites" }

      it "renders the expected template" do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/operation_sites_forms/new")
      end

      it "returns a 200 status code" do
        get request_path
        expect(response).to have_http_status(:ok)
      end

      it "includes the existing site reference in the response body" do
        get request_path
        expect(response.body).to include("Existing site description")
      end

      context "with the page parameter" do
        it "responds successfully" do
          get request_path, params: { page: 2 }
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "GET edit_operation_sites_form" do
      let(:request_path) { edit_operation_sites_forms_path(token: transient_registration.token, site_id: site_address.id) }

      it "renders the site grid reference template" do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/site_grid_reference_forms/new")
      end

      it "prefills the existing site data" do
        get request_path

        aggregate_failures do
          expect(response.body).to include("Existing site description")
          expect(response.body).to include(site_address.grid_reference)
        end
      end

      context "when the site does not exist" do
        it "raises a routing error" do
          expect do
            get edit_operation_sites_forms_path(token: transient_registration.token, site_id: "invalid")
          end.to raise_error(ActionController::RoutingError)
        end
      end
    end

    describe "POST update_operation_sites_form" do
      let(:request_path) { update_operation_sites_forms_path(token: transient_registration.token, site_id: site_address.id) }
      let(:valid_params) do
        {
          site_grid_reference_form: {
            grid_reference: "ST 12345 67890",
            description: "Updated description"
          }
        }
      end

      it "updates the existing site" do
        post request_path, params: valid_params

        aggregate_failures do
          expect(response).to redirect_to(new_operation_sites_form_path(transient_registration.token))
          expect(site_address.reload.grid_reference).to eq("ST 12345 67890")
          expect(site_address.description).to eq("Updated description")
        end
      end

      it "doesn't create a duplicate" do
        expect do
          post request_path, params: valid_params
          transient_registration.reload
        end.not_to change { transient_registration.transient_addresses.where(address_type: "site").count }
      end

      it "preserves pagination context when provided" do
        post request_path, params: valid_params.merge(page: 3)
        expect(response).to redirect_to(new_operation_sites_form_path(transient_registration.token, page: 3))
      end

      context "when the submission is invalid" do
        let(:invalid_params) do
          { site_grid_reference_form: { grid_reference: "", description: "" } }
        end

        it "re-renders the form with errors" do
          post request_path, params: invalid_params

          aggregate_failures do
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response).to render_template("waste_exemptions_engine/site_grid_reference_forms/new")
            expect(site_address.reload.description).to eq("Existing site description")
          end
        end
      end

      context "when the site cannot be found" do
        it "raises a routing error" do
          expect do
            post update_operation_sites_forms_path(token: transient_registration.token, site_id: "unknown"),
                 params: valid_params
          end.to raise_error(ActionController::RoutingError)
        end
      end
    end
  end
end
