# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsFormsHelper do
    describe "#selected_activity_exemptions" do
      it "returns a list of selected exemptions ordered by activity id and exemption id" do
        exemption_one = create(:exemption, waste_activity_id: 2)
        exemption_two = create(:exemption, waste_activity_id: 2)
        exemption_three = create(:exemption, waste_activity_id: 1)
        exemption_four = create(:exemption, waste_activity_id: 3)

        aggregate_failures "sorting waste activities" do
          exemptions = helper.selected_activity_exemptions([exemption_one.id, exemption_two.id, exemption_three.id, exemption_four.id])
          expect(exemptions.first).to eq(exemption_three)
          expect(exemptions.second).to eq(exemption_one)
          expect(exemptions.third).to eq(exemption_two)
          expect(exemptions.fourth).to eq(exemption_four)
        end
      end
    end
  end
end
