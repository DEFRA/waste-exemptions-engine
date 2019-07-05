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
  end
end
