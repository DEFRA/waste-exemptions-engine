# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Exemptions Forms" do
    before do
      WasteExemptionsEngine::Exemption.delete_all
      create_list(:exemption, 5)
    end

    include_examples "GET form", :exemptions_form, "/exemptions"
    include_examples "POST form", :exemptions_form, "/exemptions" do
      let(:form_data) { { exemption_ids: Exemption.limit(5).pluck(:id) } }
      let(:invalid_form_data) { [{ exemption_ids: [] }] }
    end

    context "when editing Exemptions on Check Your Answers page - new registration" do
      let(:exemptions_form) { build(:check_your_answers_edit_exemptions_form) }

      it "pre-fills exemptions information" do
        get "/waste_exemptions_engine/#{exemptions_form.token}/exemptions"

        exemptions_form.exemptions.each do |exemption|
          expect(response.body).to have_tag("input", with: { type: "checkbox", name: "exemptions_form[exemption_ids][]", checked: "checked", value: exemption.id.to_s })
        end
      end

      it "raises an error when no exemptions selected" do
        post "/waste_exemptions_engine/#{exemptions_form.token}/exemptions",
             params: { exemptions_form: { exemption_ids: [] } }

        aggregate_failures "error messages" do
          expect(response).not_to redirect_to(check_your_answers_forms_path(exemptions_form.token))
          expect(response.body).to include("There is a problem")
        end
      end

      it "directs to exemptions summary form when submitted" do
        post "/waste_exemptions_engine/#{exemptions_form.token}/exemptions",
             params: { exemptions_form: { exemption_ids: WasteExemptionsEngine::Exemption.limit(5).pluck(:id) } }

        expect(response).to redirect_to(exemptions_summary_forms_path(exemptions_form.token))
      end
    end

    context "when editing Exemptions on Renewal Start page - renew registration" do
      let(:exemptions_form) { build(:renewal_start_edit_exemptions_form) }

      it "pre-fills exemptions information" do
        get "/waste_exemptions_engine/#{exemptions_form.token}/exemptions"

        exemptions_form.exemptions.each do |exemption|
          expect(response.body).to have_tag("input", with: { type: "checkbox", name: "exemptions_form[exemption_ids][]", checked: "checked", value: exemption.id.to_s })
        end
      end

      it "raises an error when no exemptions selected" do
        post "/waste_exemptions_engine/#{exemptions_form.token}/exemptions",
             params: { exemptions_form: { exemption_ids: [] } }

        aggregate_failures "error messages" do
          expect(response).not_to redirect_to(renewal_start_forms_path(exemptions_form.token))
          expect(response.body).to include("There is a problem")
        end
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{exemptions_form.token}/exemptions",
             params: { exemptions_form: { exemption_ids: WasteExemptionsEngine::Exemption.limit(5).pluck(:id) } }

        expect(response).to redirect_to(renewal_start_forms_path(exemptions_form.token))
      end
    end
  end
end
