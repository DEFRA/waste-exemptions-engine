# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Confirm Activity Exemptions Forms" do
    include_examples "GET form", :confirm_activity_exemptions_form, "/your-selected-exemptions", is_charged: true
    include_examples "POST form", :confirm_activity_exemptions_form, "/your-selected-exemptions" do
      let(:form_data) { { temp_confirm_exemptions: "true" } }
      let(:invalid_form_data) { [{ temp_confirm_exemptions: nil }] }
    end

    context "when adding exemptions in the new charged registration flow" do
      let(:confirm_activity_exemptions_form) { build(:new_charged_registration_flow_confirm_activity_exemptions_form) }

      before do
        create_list(:exemption, 5)
        confirm_activity_exemptions_form.transient_registration.update(temp_exemptions: WasteExemptionsEngine::Exemption.limit(5).pluck(:id))
      end

      it "directs to confirm activity exemptions form when submitted" do
        post "/waste_exemptions_engine/#{confirm_activity_exemptions_form.token}/your-selected-exemptions",
             params: { confirm_activity_exemptions_form: { temp_confirm_exemptions: "true" } }

        expect(response).to redirect_to(exemptions_summary_forms_path(confirm_activity_exemptions_form.token))
      end
    end
  end
end
