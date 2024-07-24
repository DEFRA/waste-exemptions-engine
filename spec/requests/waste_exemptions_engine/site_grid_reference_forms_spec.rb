# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Site Grid Reference Forms" do
    include_examples "GET form", :site_grid_reference_form, "/site-grid-reference"
    include_examples "POST form", :site_grid_reference_form, "/site-grid-reference" do
      let(:form_data) do
        {
          grid_reference: "ST 58337 72855",
          description: "The waste is stored in an out-building next to the barn."
        }
      end

      let(:invalid_form_data) do
        [
          {
            grid_reference: nil,
            description: nil
          }
        ]
      end
    end

    context "with skip to check site address form" do
      let(:form) { build(:site_grid_reference_form) }
      let(:site_address_request_path) { skip_to_address_site_grid_reference_forms_path(token: form.token) }

      describe "GET site_address_request_path" do
        it "renders the appropriate template" do
          get site_address_request_path

          expect(response.location).to include(check_site_address_forms_path(token: form.token))
        end

        it "returns a 303 status code" do
          get site_address_request_path

          expect(response).to have_http_status(:see_other)
        end
      end
    end

    context "when editing an existing registration" do
      let(:edit_site_grid_reference_form) { build(:edit_site_grid_reference_form) }

      it "pre-fills site grid reference information" do
        get "/waste_exemptions_engine/#{edit_site_grid_reference_form.token}/site-grid-reference"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(edit_site_grid_reference_form.grid_reference)
          expect(response.body).to have_html_escaped_string(edit_site_grid_reference_form.description)
        end
      end
    end

    context "when renewing an existing registration" do
      let(:form) { build(:renew_site_grid_reference_form) }

      it "pre-fills site grid reference information" do
        get "/waste_exemptions_engine/#{form.token}/site-grid-reference"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(form.grid_reference)
          expect(response.body).to have_html_escaped_string(form.description)
        end
      end

      context "with skip to check site address form" do
        let(:site_address_request_path) { skip_to_address_site_grid_reference_forms_path(token: form.token) }

        describe "GET site_address_request_path" do
          it "renders the appropriate template" do
            get site_address_request_path

            expect(response.location).to include(check_site_address_forms_path(token: form.token))
          end

          it "returns a 303 status code" do
            get site_address_request_path

            expect(response).to have_http_status(:see_other)
          end
        end
      end
    end

    context "when editing site grid reference on Check Your Answers page - new registration" do
      let(:check_site_address_form) { build(:check_your_answers_check_site_address_form) }
      let(:transient_registration) { create(:new_registration, workflow_state: "check_site_address_form") }

      context "when reusing the operator address" do
        let(:form_data) { { temp_reuse_address_for_site_location: "operator_address_option" } }

        it "redirects back to check-your-answers when submitted" do
          post "/waste_exemptions_engine/#{check_site_address_form.token}/check-site-address",
               params: { check_site_address_form: form_data }
          expect(response).to redirect_to(check_your_answers_forms_path(check_site_address_form.token))
        end
      end

      context "when selecting another address" do
        let(:form_data) { { temp_reuse_address_for_site_location: "a_different_address" } }

        it "redirects to the post code form when submitted" do
          post "/waste_exemptions_engine/#{check_site_address_form.token}/check-site-address",
               params: { check_site_address_form: form_data }
          expect(response).to redirect_to(site_postcode_forms_path(check_site_address_form.token))
        end
      end
    end
  end
end
