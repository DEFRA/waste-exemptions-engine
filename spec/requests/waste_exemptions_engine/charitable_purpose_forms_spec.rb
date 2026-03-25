# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Charitable Purpose Forms" do
    it_behaves_like "GET form", :charitable_purpose_form, "/charitable-purpose"
    it_behaves_like "POST form", :charitable_purpose_form, "/charitable-purpose" do
      let(:form_data) { { charitable_purpose: "true" } }
      let(:invalid_form_data) { [] }
    end

    context "when editing charitable purpose on Check Your Answers page - new registration" do
      let(:charitable_purpose_form) { build(:check_your_answers_edit_charitable_purpose_form) }

      it "pre-fills charitable purpose information" do
        get "/waste_exemptions_engine/#{charitable_purpose_form.token}/charitable-purpose"

        expect(response.body).to have_tag("input", with: { type: "radio", name: "charitable_purpose_form[charitable_purpose]", checked: "checked", value: "true" })
      end

      it "redirects to the declaration form when charitable purpose is true" do
        post "/waste_exemptions_engine/#{charitable_purpose_form.token}/charitable-purpose",
             params: { charitable_purpose_form: { charitable_purpose: true } }

        expect(response).to redirect_to(charitable_purpose_declaration_forms_path(charitable_purpose_form.token))
      end

      it "redirects to exemptions summary when charitable purpose is false" do
        post "/waste_exemptions_engine/#{charitable_purpose_form.token}/charitable-purpose",
             params: { charitable_purpose_form: { charitable_purpose: false } }

        expect(response).to redirect_to(exemptions_summary_forms_path(charitable_purpose_form.token))
      end
    end
  end
end
