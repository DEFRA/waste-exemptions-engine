# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsFormsHelper do
    describe "#selected_activity_exemptions" do
      let(:activity_one) { create(:waste_activity) }
      let(:activity_two) { create(:waste_activity) }
      let(:activity_three) { create(:waste_activity) }
      let(:transient_registration) { create(:new_charged_registration, temp_waste_activities:) }
      let(:temp_waste_activities) { [activity_one.id, activity_two.id, activity_three.id] }
      let(:farming_exemptions) { create_list(:exemption, 2, waste_activity: activity_one) }
      let(:non_farming_exemptions) { create_list(:exemption, 2, waste_activity: activity_two) }

      before do
        # Actually create the exemptions in the database
        farming_exemptions
        non_farming_exemptions
      end

      it "returns all exemptions for selected activities, including farming exemptions", :aggregate_failures do
        exemptions = helper.selected_activity_exemptions(transient_registration)

        expect(exemptions).to include(*farming_exemptions)
        expect(exemptions).to include(*non_farming_exemptions)
      end
    end
  end
end
