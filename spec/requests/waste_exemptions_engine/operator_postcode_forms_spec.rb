# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operator Postcode Forms" do
    it_behaves_like "GET form", :operator_postcode_form, "/operator-postcode"
    it_behaves_like "POST form", :operator_postcode_form, "/operator-postcode" do
      let(:form_data) { { temp_operator_postcode: "BS1 5AH" } }
      let(:invalid_form_data) { [{ temp_operator_postcode: "BA" }, { temp_operator_postcode: nil }] }
    end

    it_behaves_like "skip to manual address",
                    :operator_postcode_form,
                    address_type: :operator

    context "when editing an existing registration" do
      let(:edit_operator_postcode_form) { build(:edit_operator_postcode_form) }

      it "pre-fills operator postcode information" do
        get "/waste_exemptions_engine/#{edit_operator_postcode_form.token}/operator-postcode"

        expect(response.body).to have_html_escaped_string(edit_operator_postcode_form.temp_operator_postcode)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_operator_postcode_form) { build(:renew_operator_postcode_form) }

      it "pre-fills operator postcode information" do
        get "/waste_exemptions_engine/#{renew_operator_postcode_form.token}/operator-postcode"

        expect(response.body).to have_html_escaped_string(renew_operator_postcode_form.temp_operator_postcode)
      end
    end
  end
end
