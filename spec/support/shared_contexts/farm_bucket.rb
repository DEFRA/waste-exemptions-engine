# frozen_string_literal: true

# rubocop:disable RSpec/ContextWording
RSpec.shared_context "farm bucket" do
  include_context "with bands and charges"

  let(:bucket) { create(:bucket, bucket_type: "farmer") }
  let(:activity_d) { build(:waste_activity) }
  let(:activity_t) { build(:waste_activity) }
  let(:activity_u) { build(:waste_activity) }

  let(:farm_exemptions) do
    [
      create(:exemption, waste_activity: activity_t, band: band_1, code: "T2"),
      create(:exemption, waste_activity: activity_t, band: band_1, code: "T1"),
      create(:exemption, waste_activity: activity_d, band: band_2, code: "D1"),
      create(:exemption, waste_activity: activity_d, band: band_2, code: "D2"),
      create(:exemption, waste_activity: activity_u, band: band_3, code: "U4"),
      create(:exemption, waste_activity: activity_u, band: band_3, code: "U3")
    ]
  end

  let(:non_farm_exemptions) do
    [
      create(:exemption, waste_activity: activity_t, band: band_1, code: "T4"),
      create(:exemption, waste_activity: activity_u, band: band_3, code: "U1")
    ]
  end

  let!(:bucket_exemptions) do # rubocop:disable RSpec/LetSetup
    farm_exemptions.map { |exemption| create(:bucket_exemption, bucket:, exemption:) }
  end

end
# rubocop:enable RSpec/ContextWording
