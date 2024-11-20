# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe WasteActivitiesFormsHelper do
    describe "#waste_activities_sorted" do
      it "returns a list of all waste activities ordered by category in the following order: 1. using_waste 2. disposing_of_waste 3. treating_waste 4. storing_waste" do
        waste_activity_storing_waste = create(:waste_activity, category: "storing_waste")
        waste_activity_treating_waste = create(:waste_activity, category: "treating_waste")
        waste_activity_disposing_of_waste = create(:waste_activity, category: "disposing_of_waste")
        waste_activities_using_waste = create(:waste_activity, category: "using_waste")

        aggregate_failures "sorting waste activities" do
          expect(helper.waste_activities_sorted.first).to eq(waste_activities_using_waste)
          expect(helper.waste_activities_sorted.second).to eq(waste_activity_disposing_of_waste)
          expect(helper.waste_activities_sorted.third).to eq(waste_activity_treating_waste)
          expect(helper.waste_activities_sorted.fourth).to eq(waste_activity_storing_waste)
        end
      end
    end
  end
end
