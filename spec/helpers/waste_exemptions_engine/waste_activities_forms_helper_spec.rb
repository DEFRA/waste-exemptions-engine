# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe WasteActivitiesFormsHelper do
    describe "#all_categories" do
      it "returns a list of all waste activity categories" do
        expect(helper.all_categories).to eq(WasteActivity::ACTIVITY_CATEGORIES.keys)
      end
    end

    describe "#category_activities" do
      let(:category) { WasteActivity::ACTIVITY_CATEGORIES.keys.sample }

      before do
        create_list(:waste_activity, 5)
      end

      it "returns a list of waste activities filtered by category" do
        expect(helper.category_activities(category)).to eq(WasteActivity.where(category: category))
      end
    end

    describe "#exemption_codes_for_activity" do
      let(:activity) { create(:waste_activity) }

      before do
        create(:exemption, code: "U1", waste_activity: activity)
        create(:exemption, code: "U2", waste_activity: activity)
        create(:exemption, code: "U3", waste_activity: activity)
      end

      it "returns a comma-separated list of exemption codes in ascending order" do
        expect(helper.exemption_codes_for_activity(activity)).to eq("U1, U2, U3")
      end

      context "when activity has no exemptions" do
        let(:activity_without_exemptions) { create(:waste_activity) }

        it "returns an empty string" do
          expect(helper.exemption_codes_for_activity(activity_without_exemptions)).to eq("")
        end
      end
    end
  end
end
