# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Activity Exemptions Forms" do
    include_context "farm bucket"

    include_examples "GET form", :activity_exemptions_form, "/select-waste-exemptions", is_charged: true
    include_examples "POST form", :activity_exemptions_form, "/select-waste-exemptions" do
      let(:form_data) { { temp_exemptions: Exemption.limit(5).pluck(:id) } }
      let(:invalid_form_data) { [{ temp_exemptions: nil }, { temp_exemptions: [] }] }
    end

    context "when selecting a T28 exemption" do
      let(:activity_exemptions_form) { build(:activity_exemptions_form) }
      let(:t28_exemption) { create(:exemption, code: "T28") }

      context "in the front office" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
        end

        it "shows a validation error when T28 is selected" do
          post "/waste_exemptions_engine/#{activity_exemptions_form.token}/select-waste-exemptions",
               params: { activity_exemptions_form: { temp_exemptions: [t28_exemption.id] } }

          expect(response).to have_http_status(:ok)
          expect(response.body).to include(
            I18n.t("activemodel.errors.models.waste_exemptions_engine/activity_exemptions_form.attributes.temp_exemptions.t28_exemption_selected")
          )
        end
      end

      context "in the back office" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true)
        end

        it "does not show a validation error when T28 is selected" do
          post "/waste_exemptions_engine/#{activity_exemptions_form.token}/select-waste-exemptions",
               params: { activity_exemptions_form: { temp_exemptions: [t28_exemption.id] } }

          expect(response).to have_http_status(:see_other) # 303 redirect on success
          expect(response).not_to have_http_status(:ok) # Not staying on the same page with errors
        end
      end
    end

    context "when adding exemptions in the new charged registration flow" do
      let(:activity_exemptions_form) { build(:new_charged_registration_flow_activity_exemptions_form) }

      it "directs to confirm activity exemptions form when submitted" do
        post "/waste_exemptions_engine/#{activity_exemptions_form.token}/select-waste-exemptions",
             params: { activity_exemptions_form: { temp_exemptions: WasteExemptionsEngine::Exemption.limit(5).pluck(:id) } }

        expect(response).to redirect_to(confirm_activity_exemptions_forms_path(activity_exemptions_form.token))
      end
    end
  end
end
