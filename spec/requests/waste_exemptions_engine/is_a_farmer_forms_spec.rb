# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Is a Farmer Forms" do
    include_examples "GET form", :is_a_farmer_form, "/is-a-farmer"
    include_examples "POST form", :is_a_farmer_form, "/is-a-farmer" do
      let(:form_data) { { is_a_farmer: "true" } }
      let(:invalid_form_data) { [] }
    end

    context "when editing Is a Farmer on Check Your Answers page - new registration" do
      let(:is_a_farmer_form) { build(:check_your_answers_edit_is_a_farmer_form) }

      it "pre-fills is-a-farmer information" do
        get "/waste_exemptions_engine/#{is_a_farmer_form.token}/is-a-farmer"

        expect(response.body).to have_tag("input", with: { type: "radio", name: "is_a_farmer_form[is_a_farmer]", checked: "checked", value: "true" })
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{is_a_farmer_form.token}/is-a-farmer",
             params: { is_a_farmer_form: { is_a_farmer: true } }

        expect(response).to redirect_to(check_your_answers_forms_path(is_a_farmer_form.token))
      end
    end

    context "when editing Is a Farmer on Renewals Start page - renew registration" do
      let(:is_a_farmer_form) { build(:renewal_start_edit_is_a_farmer_form) }

      it "pre-fills is-a-farmer information" do
        get "/waste_exemptions_engine/#{is_a_farmer_form.token}/is-a-farmer"

        expect(response.body).to have_tag("input", with: { type: "radio", name: "is_a_farmer_form[is_a_farmer]", checked: "checked", value: "true" })
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{is_a_farmer_form.token}/is-a-farmer",
             params: { is_a_farmer_form: { is_a_farmer: true } }

        expect(response).to redirect_to(renewal_start_forms_path(is_a_farmer_form.token))
      end
    end
  end
end
