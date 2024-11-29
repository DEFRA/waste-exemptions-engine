# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Activity Exemptions Forms" do
    before do
      create_list(:exemption, 5)
    end

    include_examples "GET form", :activity_exemptions_form, "/select-waste-exemptions", is_charged: true
    include_examples "POST form", :activity_exemptions_form, "/select-waste-exemptions" do
      let(:form_data) { { temp_exemptions: Exemption.limit(5).pluck(:id) } }
      let(:invalid_form_data) { [{ temp_exemptions: nil }] }
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
