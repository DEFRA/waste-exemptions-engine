# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Waste Activities Forms" do
    before do
      create_list(:waste_activity, 5)
    end

    include_examples "GET form", :waste_activities_form, "/select-waste-activities"
    include_examples "POST form", :waste_activities_form, "/select-waste-activities" do
      let(:form_data) { { temp_waste_activities: WasteActivity.limit(5).pluck(:id) } }
      let(:invalid_form_data) { [{ temp_waste_activities: nil }] }
    end

    context "when adding waste_activities in the new charged registration flow" do
      let(:waste_activities_form) { build(:new_charged_registration_flow_waste_activities_form) }

      it "directs to exemptions form when submitted" do
        post "/waste_exemptions_engine/#{waste_activities_form.token}/select-waste-activities",
             params: { waste_activities_form: { temp_waste_activities: WasteExemptionsEngine::WasteActivity.limit(5).pluck(:id) } }

        expect(response).to redirect_to(exemptions_forms_path(waste_activities_form.token))
      end
    end
  end
end
