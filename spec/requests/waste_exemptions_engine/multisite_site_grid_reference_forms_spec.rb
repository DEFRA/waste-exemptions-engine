# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Multisite Site Grid Reference Forms" do
    include_examples "GET form", :multisite_site_grid_reference_form, "/multisite-site-grid-reference", is_charged: true
    include_examples "POST form", :multisite_site_grid_reference_form, "/multisite-site-grid-reference", is_charged: true do
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

    context "with skip to multisite site address form" do
      let(:form) { build(:multisite_site_grid_reference_form) }
      let(:site_address_request_path) { skip_to_address_multisite_site_grid_reference_forms_path(token: form.token) }

      describe "GET site_address_request_path" do
        it "renders the appropriate template" do
          get site_address_request_path

          expect(response.location).to include(multisite_site_postcode_forms_path(token: form.token))
        end

        it "returns a 303 status code" do
          get site_address_request_path

          expect(response).to have_http_status(:see_other)
        end
      end
    end

    context "when editing Multisite Site Grid Reference on Check Your Answers page - new registration" do
      let(:multisite_site_grid_reference_form) { build(:check_your_answers_multisite_site_grid_reference_form) }

      it "continues through the multisite workflow when form is submitted" do
        post "/waste_exemptions_engine/#{multisite_site_grid_reference_form.token}/multisite-site-grid-reference",
             params: { multisite_site_grid_reference_form: {
               description: "Updated site description",
               grid_reference: "ST1234567890"
             } }

        expect(response).to have_http_status(:see_other)
      end

      it "does not redirect to check your answers page when form is submitted" do
        post "/waste_exemptions_engine/#{multisite_site_grid_reference_form.token}/multisite-site-grid-reference",
             params: { multisite_site_grid_reference_form: {
               description: "Updated site description",
               grid_reference: "ST1234567890"
             } }

        expect(response).not_to redirect_to(check_your_answers_forms_path(multisite_site_grid_reference_form.token))
      end

      it "progresses to multiple_sites_form when form is submitted" do
        post "/waste_exemptions_engine/#{multisite_site_grid_reference_form.token}/multisite-site-grid-reference",
             params: { multisite_site_grid_reference_form: {
               description: "Updated site description",
               grid_reference: "ST1234567890"
             } }

        expect(response).to redirect_to(multiple_sites_forms_path(multisite_site_grid_reference_form.token))
      end
    end
  end
end
