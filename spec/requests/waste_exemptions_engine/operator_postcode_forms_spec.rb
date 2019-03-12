# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operator Postcode Forms", type: :request do
    include_examples "GET form", :operator_postcode_form, "/operator-postcode"
    include_examples "go back", :operator_postcode_form, "/operator-postcode/back"
    include_examples "POST form", :operator_postcode_form, "/operator-postcode" do
      let(:form_data) { { postcode: "BS1 5AH" } }
    end

    include_examples "skip to manual address",
                     :operator_postcode_form,
                     request_path: "/operator-postcode/skip_to_manual_address",
                     result_path: "/operator-address-manual"
  end
end
