# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Site Grid Reference Forms", type: :request do
    include_examples "GET form", :site_grid_reference_form, "/site-grid-reference"
    include_examples "go back", :site_grid_reference_form, "/site-grid-reference/back"
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

    include_examples "skip to manual address",
                     :site_grid_reference_form,
                     request_path: "/site-grid-reference/skip_to_address",
                     result_path: "/site-postcode"

    context "when editing an existing registration" do
      let(:edit_site_grid_reference_form) { build(:edit_site_grid_reference_form) }

      it "prefils site grid reference information" do
        get "/waste_exemptions_engine/site-grid-reference/#{edit_site_grid_reference_form.token}"

        expect(response.body).to include(edit_site_grid_reference_form.grid_reference)
        expect(response.body).to include(edit_site_grid_reference_form.description)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_site_grid_reference_form) { build(:renew_site_grid_reference_form) }

      it "prefils site grid reference information" do
        get "/waste_exemptions_engine/site-grid-reference/#{renew_site_grid_reference_form.token}"

        expect(response.body).to include(renew_site_grid_reference_form.grid_reference)
        expect(response.body).to include(renew_site_grid_reference_form.description)
      end
    end
  end
end
