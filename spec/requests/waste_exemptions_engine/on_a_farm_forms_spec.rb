# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "On a Farm Forms" do
    it_behaves_like "GET form", :on_a_farm_form, "/on-a-farm"
    it_behaves_like "POST form", :on_a_farm_form, "/on-a-farm" do
      let(:form_data) { { on_a_farm: "true" } }
      let(:invalid_form_data) { [] }
    end

    context "when editing on-a-farm on Check Your Answers page - new registration" do
      let(:on_a_farm_form) { build(:check_your_answers_edit_on_a_farm_form) }

      it "pre-fills on-a-farm information" do
        get "/waste_exemptions_engine/#{on_a_farm_form.token}/on-a-farm"

        expect(response.body).to have_tag("input", with: { type: "radio", name: "on_a_farm_form[on_a_farm]", checked: "checked", value: "true" })

      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{on_a_farm_form.token}/on-a-farm",
             params: { on_a_farm_form: { on_a_farm: false } }

        expect(response).to redirect_to(check_your_answers_forms_path(on_a_farm_form.token))
      end
    end

    context "when editing on-a-farm on Renewal Start page - renew registration" do
      let(:on_a_farm_form) { build(:renewal_start_edit_on_a_farm_form) }

      it "pre-fills on-a-farm information" do
        get "/waste_exemptions_engine/#{on_a_farm_form.token}/on-a-farm"

        expect(response.body).to have_tag("input", with: { type: "radio", name: "on_a_farm_form[on_a_farm]", checked: "checked", value: "true" })

      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{on_a_farm_form.token}/on-a-farm",
             params: { on_a_farm_form: { on_a_farm: false } }

        expect(response).to redirect_to(renewal_start_forms_path(on_a_farm_form.token))
      end
    end
  end
end
