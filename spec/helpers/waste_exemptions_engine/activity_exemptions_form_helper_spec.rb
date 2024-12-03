# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsFormsHelper do
    describe "#selected_activity_exemptions" do
      let(:activity_one) { create(:waste_activity) }
      let(:activity_two) { create(:waste_activity) }
      let(:activity_three) { create(:waste_activity) }

      it "returns a list of selected exemptions ordered by activity id and exemption id" do
        aggregate_failures "sorting waste activities" do
          activity_ids = [activity_one.id, activity_two.id, activity_three.id]
          create_list(:exemption, 4, waste_activity_id: activity_ids.sample)

          exemptions = helper.selected_activity_exemptions(activity_ids)
          exemption_acivity_ids = exemptions.map(&:waste_activity_id)
          expect(exemptions.first.waste_activity_id).to eq(exemption_acivity_ids.min)
          expect(exemptions.second.waste_activity_id).to be >= exemption_acivity_ids.min
          expect(exemptions.third.waste_activity_id).to be <= exemption_acivity_ids.max
          expect(exemptions.last.waste_activity_id).to eq(exemption_acivity_ids.max)
        end
      end
    end
  end
end
