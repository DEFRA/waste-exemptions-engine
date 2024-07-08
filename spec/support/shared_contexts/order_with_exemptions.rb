# frozen_string_literal: true

RSpec.shared_context "with an order with exemptions" do
  let(:single_band_single_exemption) { [create(:exemption, band: band_1)] }
  let(:single_band_multiple_exemptions) { create_list(:exemption, 3, band: band_1) }
  let(:multiple_bands_multiple_exemptions) do
    [
      create_list(:exemption, 3, band: band_1),
      create_list(:exemption, 2, band: band_2),
      create_list(:exemption, 1, band: band_3)
    ].flatten
  end

  let(:order) { create(:order, exemptions:) }
end
