# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OrderChargeBreakdown do
    subject(:breakdown) { described_class.new(order:) }

    let(:order) do
      instance_double(Order,
                      exemptions: [additional_exemption, initial_exemption, no_charge_exemption, bucket_exemption],
                      bucket:,
                      charge_detail:)
    end
    let(:bucket) { instance_double(Bucket, exemptions: [bucket_exemption]) }
    let(:initial_exemption) { instance_double(Exemption, code: "U1", band_id: 1) }
    let(:additional_exemption) { instance_double(Exemption, code: "U10", band_id: 1) }
    let(:no_charge_exemption) { instance_double(Exemption, code: "T28", band_id: 2) }
    let(:bucket_exemption) { instance_double(Exemption, code: "U12", band_id: 3) }
    let(:charged_band_detail) do
      instance_double(BandChargeDetail,
                      band_id: 1,
                      initial_compliance_charge_amount: 43_596,
                      additional_compliance_charge_amount: 7889,
                      total_compliance_charge_amount: 51_485)
    end
    let(:no_charge_band_detail) do
      instance_double(BandChargeDetail,
                      band_id: 2,
                      initial_compliance_charge_amount: 0,
                      additional_compliance_charge_amount: 0,
                      total_compliance_charge_amount: 0)
    end
    let(:charge_detail) do
      instance_double(ChargeDetail,
                      band_charge_details: [charged_band_detail, no_charge_band_detail],
                      bucket_charge_amount: 3114,
                      registration_charge_amount: 5813,
                      total_compliance_charge_amount_excluding_bucket: 51_485,
                      total_charge_amount: 60_412)
    end

    describe "#exemption_charges" do
      it "allocates persisted initial and additional band charges to sorted exemptions" do
        expect(breakdown.exemption_charges.map { |item| [item.exemption.code, item.amount_pence] }).to eq(
          [["U1", 43_596], ["U10", 7889], ["T28", 0]]
        )
      end
    end

    describe "exemption groups" do
      it "identifies bucket exemptions" do
        expect(breakdown.bucket_exemptions).to eq([bucket_exemption])
      end

      it "identifies chargeable exemptions" do
        expect(breakdown.chargeable_exemptions).to contain_exactly(initial_exemption, additional_exemption)
      end

      it "identifies no-charge exemptions" do
        expect(breakdown.no_charge_exemptions).to eq([no_charge_exemption])
      end
    end

    describe "persisted totals" do
      it { expect(breakdown.bucket_charge_amount).to eq(3114) }
      it { expect(breakdown.registration_charge_amount).to eq(5813) }
      it { expect(breakdown.total_compliance_charge_amount_excluding_bucket).to eq(51_485) }
      it { expect(breakdown.total_charge_amount).to eq(60_412) }
    end
  end
end
