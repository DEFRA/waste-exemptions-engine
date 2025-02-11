# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmActivityExemptionsFormsHelper do
    let(:bands) { create_list(:band, 3) }

    describe "#selected_exemptions" do
      it "returns a list of selected exemptions ordered by band id and exemption id" do
        exemption_one = create(:exemption, band: bands[1])
        exemption_two = create(:exemption, band: bands[1])
        exemption_three = create(:exemption, band: bands[0])
        exemption_four = create(:exemption, band: bands[2])

        aggregate_failures "sorting waste activities" do
          exemptions = helper.selected_exemptions([exemption_one.id, exemption_two.id, exemption_three.id, exemption_four.id])
          expect(exemptions.first).to eq(exemption_three)
          expect(exemptions.second).to eq(exemption_one)
          expect(exemptions.third).to eq(exemption_two)
          expect(exemptions.fourth).to eq(exemption_four)
        end
      end
    end
  end
end
