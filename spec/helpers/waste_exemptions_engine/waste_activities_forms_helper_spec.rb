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
      let(:regular_exemptions) { create_list(:exemption, 3, waste_activity: activity) }
      let(:farm_exemption) { create(:exemption, code: "U4", waste_activity: activity) }

      before do
        # Create exemptions in the database
        regular_exemptions
        farm_exemption
      end

      it "returns a comma-separated list of exemption codes" do
        result = helper.exemption_codes_for_activity(activity)
        result_codes = result.split(", ").sort
        expected_codes = (regular_exemptions + [farm_exemption]).map(&:code).sort
        expect(result_codes).to eq(expected_codes)
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
