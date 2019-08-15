# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operator Postcode Forms", type: :request do
    include_examples "GET form", :operator_postcode_form, "/operator-postcode"
    include_examples "go back", :operator_postcode_form, "/operator-postcode/back"
    include_examples "POST form", :operator_postcode_form, "/operator-postcode" do
      let(:form_data) { { postcode: "BS1 5AH" } }
      let(:invalid_form_data) { [{ postcode: "BA" }, { postcode: nil }] }
    end

    include_examples "skip to manual address",
                     :operator_postcode_form,
                     request_path: "/operator-postcode/skip_to_manual_address",
                     result_path: "/operator-address-manual"


    context "when editing an existing registration" do
      let(:edit_operator_postcode_form) { build(:edit_operator_postcode_form) }

      it "prefils operator postcode information" do
        get "/waste_exemptions_engine/operator-postcode/#{edit_operator_postcode_form.token}"

        expect(response.body).to include(edit_operator_postcode_form.postcode)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_operator_postcode_form) { build(:renew_operator_postcode_form) }

      it "prefils operator postcode information" do
        get "/waste_exemptions_engine/operator-postcode/#{renew_operator_postcode_form.token}"

        expect(response.body).to include(renew_operator_postcode_form.postcode)
      end
    end
  end
end
