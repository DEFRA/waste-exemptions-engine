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
  end
end
