# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operator Name Forms" do
    include_examples "GET form", :operator_name_form, "/operator-name"
    include_examples "POST form", :operator_name_form, "/operator-name" do
      let(:form_data) { { operator_name: "Acme Waste Carriers" } }
      let(:invalid_form_data) { [{ operator_name: nil }] }
    end

    context "when editing operator name on Check Your Answers page - new registration" do
      let(:operator_name_form) { build(:check_your_answers_edit_operator_name_form) }

      it "pre-fills operator name information" do
        get "/waste_exemptions_engine/#{operator_name_form.token}/operator-name"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(operator_name_form.operator_name)
          expect(response.body).to have_html_escaped_string(operator_name_form.operator_name)
        end
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{operator_name_form.token}/operator-name",
             params: { operator_name_form: { operator_name: "Smith ltd" } }

        expect(response).to redirect_to(check_your_answers_forms_path(operator_name_form.token))
      end
    end

    context "when editing an existing registration" do
      let(:edit_operator_name_form) { build(:edit_operator_name_form) }

      it "pre-fills operator name information" do
        get "/waste_exemptions_engine/#{edit_operator_name_form.token}/operator-name"

        expect(response.body).to have_html_escaped_string(edit_operator_name_form.operator_name)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_operator_name_form) { build(:renew_operator_name_form) }

      it "pre-fills operator name information" do
        get "/waste_exemptions_engine/#{renew_operator_name_form.token}/operator-name"

        expect(response.body).to have_html_escaped_string(renew_operator_name_form.operator_name)
      end
    end
  end
end
