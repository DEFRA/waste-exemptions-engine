# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmActivityExemptionsFormsHelper do
    let(:band) { create(:band) }
    let!(:exemption_a) { create(:exemption, id: 1, band: band) }
    let!(:exemption_b) { create(:exemption, id: 2, band: band) }
    let!(:exemption_c) { create(:exemption, id: 3, band: band) }

    describe "#selected_exemptions" do
      it "returns a list of selected exemptions ordered by id" do
        exemption_ids = [exemption_c.id, exemption_a.id, exemption_b.id]
        exemptions = helper.selected_exemptions(exemption_ids)

        expect(exemptions.map(&:id)).to eq([exemption_a.id, exemption_b.id, exemption_c.id])
      end
    end
  end
end
