# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Waste Activities Forms" do
    let(:activity_one) { create(:waste_activity, category: :using_waste) }
    let(:activity_two) { create(:waste_activity, category: :storing_waste) }
    let(:activity_three) { create(:waste_activity, category: :disposing_of_waste) }
    let(:activity_ids) { [activity_one.id, activity_two.id, activity_three.id] }

    it_behaves_like "GET form", :waste_activities_form, "/select-waste-activities", is_charged: true
    it_behaves_like "POST form", :waste_activities_form, "/select-waste-activities" do
      let(:form_data) { { temp_waste_activities: activity_ids } }
      let(:invalid_form_data) { [{ temp_waste_activities: nil }] }
    end

    context "when adding waste_activities in the new charged registration flow" do
      let(:waste_activities_form) { build(:new_charged_registration_flow_waste_activities_form) }

      it "directs to activity_exemptions form when submitted" do
        post "/waste_exemptions_engine/#{waste_activities_form.token}/select-waste-activities",
             params: { waste_activities_form: { temp_waste_activities: activity_ids } }

        expect(response).to redirect_to(activity_exemptions_forms_path(waste_activities_form.token))
      end
    end
  end
end
