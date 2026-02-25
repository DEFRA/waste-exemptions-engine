# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmActivityExemptionsFormsHelper do
    let(:bands) { create_list(:band, 3) }
    let!(:band_one_exemption_a) { create(:exemption, id: 2, band: bands[0]) }
    let!(:band_one_exemption_b) { create(:exemption, id: 4, band: bands[0]) }
    let!(:band_two_exemption_a) { create(:exemption, id: 1, band: bands[1]) }
    let!(:band_two_exemption_b) { create(:exemption, id: 3, band: bands[1]) }

    describe "#selected_exemptions" do
      it "returns a list of selected exemptions ordered by band id and exemption id" do
        exemption_ids = [band_two_exemption_a.id, band_two_exemption_b.id,
                         band_one_exemption_a.id, band_one_exemption_b.id]
        exemptions = helper.selected_exemptions(exemption_ids)

        expect(exemptions.map(&:id)).to eq([band_one_exemption_a.id, band_one_exemption_b.id,
                                            band_two_exemption_a.id, band_two_exemption_b.id])
      end
    end

    describe "#exemptions_by_band" do
      it "groups exemptions by band in band order" do
        exemptions = helper.selected_exemptions([
                                                  band_two_exemption_b.id,
                                                  band_one_exemption_b.id,
                                                  band_two_exemption_a.id,
                                                  band_one_exemption_a.id
                                                ])

        result = helper.exemptions_by_band(exemptions)

        expect(result.map { |group| group[:name] }).to eq([bands[0].name, bands[1].name])
        expect(result.first[:exemptions].map(&:id)).to eq([band_one_exemption_a.id, band_one_exemption_b.id])
        expect(result.second[:exemptions].map(&:id)).to eq([band_two_exemption_a.id, band_two_exemption_b.id])
      end
    end
  end
end
