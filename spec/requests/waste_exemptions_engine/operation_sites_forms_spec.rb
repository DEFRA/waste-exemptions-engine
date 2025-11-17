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

    describe "GET edit_site_operation_sites_form" do
      let(:request_path) { edit_site_operation_sites_forms_path(token: transient_registration.token, site_id: site_address.id) }

      it "sets the temp_site_id" do
        expect { get request_path }.to change { transient_registration.reload.temp_site_id }.from(nil).to(site_address.id)
      end

      it "redirects to the new site_grid_reference_form page" do
        get request_path
        expect(response).to redirect_to(new_site_grid_reference_form_path(token: transient_registration.token))
      end

      context "when the site does not exist" do
        it "raises a routing error" do
          expect do
            get edit_site_operation_sites_forms_path(token: transient_registration.token, site_id: "invalid")
          end.to raise_error(ActionController::RoutingError)
        end
      end
    end

  end
end
