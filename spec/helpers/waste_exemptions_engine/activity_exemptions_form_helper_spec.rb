# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsFormsHelper do
    describe "#selected_activity_exemptions" do
      let(:activity_one) { create(:waste_activity) }
      let(:activity_two) { create(:waste_activity) }
      let(:activity_three) { create(:waste_activity) }
      let(:exemption_one) { create(:exemption, waste_activity_id: activity_one.id) }
      let(:exemption_two) { create(:exemption, waste_activity_id: activity_two.id) }
      let(:exemption_three) { create(:exemption, waste_activity_id: activity_one.id) }
      let(:exemption_four) { create(:exemption, waste_activity_id: activity_three.id) }

      it "returns a list of selected exemptions ordered by activity id and exemption id" do
        aggregate_failures "sorting waste activities" do
          exemptions = helper.selected_activity_exemptions([exemption_one.id, exemption_two.id, exemption_three.id, exemption_four.id])
          expect(exemptions.first).to eq(exemption_one)
          expect(exemptions.second).to eq(exemption_three)
          expect(exemptions.third).to eq(exemption_two)
          expect(exemptions.fourth).to eq(exemption_four)
        end
      end
    end
  end
end
