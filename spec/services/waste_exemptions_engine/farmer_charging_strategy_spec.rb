# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FarmerChargingStrategy do
    include_context "with bands and charges"
    include_context "with an order with exemptions"

    let(:bucket_exemptions) do
      [
        build_list(:exemption, 3, band: band_1),
        build_list(:exemption, 3, band: band_2),
        build_list(:exemption, 3, band: band_3)
      ].flatten
    end

    let(:bucket) { create(:bucket, :farmer_exemptions) }
    let(:bucket_charge_amount) { bucket.initial_compliance_charge.charge_amount }

    before do
      bucket.exemptions << bucket_exemptions
      order.bucket = bucket
    end

    describe "#charge_details" do
      subject(:charge_details) { described_class.new(order).charge_details }
      let(:band_charges) { charge_details.band_charge_details }
      let(:total_compliance_charge_amount) do
        band_charges.sum { |bc| bc.initial_compliance_charge_amount + bc.additional_compliance_charge_amount }
      end

      context "when there are no farmer bucket exemptions in the order" do
        # let(:exemptions) { multiple_bands_multiple_exemptions }

        it_behaves_like "non-bucket charging strategy #charge_details"
      end

      context "with an order with bucket exemptions only" do
        let(:exemptions) { bucket_exemptions }

        it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }

        it { expect(band_charges.length).to eq 3 }
        it { expect(band_charges[0].initial_compliance_charge_amount).to be_zero }
        it { expect(band_charges[1].initial_compliance_charge_amount).to be_zero }
        it { expect(band_charges[2].initial_compliance_charge_amount).to be_zero }

        it { expect(charge_details.bucket_charge_amount).to eq bucket_charge_amount }

        it { expect(charge_details.total_compliance_charge_amount).to eq bucket_charge_amount }
        it { expect(charge_details.total_charge_amount).to eq registration_charge_amount + bucket_charge_amount }
      end

      context "with an order with both bucket and non-bucket exemptions" do
        let(:exemptions) { bucket_exemptions + multiple_bands_multiple_exemptions }

        it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }

        it { expect(band_charges.length).to eq 3 }
        it { expect(band_charges[0].initial_compliance_charge_amount).to be_zero }
        it { expect(band_charges[0].additional_compliance_charge_amount).to eq(3 * band_1.additional_compliance_charge.charge_amount) }

        it { expect(band_charges[1].initial_compliance_charge_amount).to be_zero }
        it { expect(band_charges[1].additional_compliance_charge_amount).to eq(2 * band_2.additional_compliance_charge.charge_amount) }

        it { expect(band_charges[2].initial_compliance_charge_amount).to be_zero }
        it { expect(band_charges[2].additional_compliance_charge_amount).to eq(1 * band_3.additional_compliance_charge.charge_amount) }

        it { expect(charge_details.bucket_charge_amount).to eq bucket_charge_amount }

        it do
          expect(charge_details.total_compliance_charge_amount).to eq(
            bucket_charge_amount +
            band_charges.sum { |bc| bc.initial_compliance_charge_amount + bc.additional_compliance_charge_amount }
          )
        end

        it do
          expect(charge_details.total_charge_amount).to eq(
            registration_charge_amount +
            total_compliance_charge_amount +
            bucket_charge_amount
          )
        end
      end
    end
  end
end
