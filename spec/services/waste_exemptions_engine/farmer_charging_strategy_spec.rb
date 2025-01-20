# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FarmerChargingStrategy do

    describe "#charge_details" do
      subject(:charge_details) { described_class.new(order).charge_detail }

      let(:bucket) { create(:bucket) }
      let(:bucket_charge_amount) { bucket.initial_compliance_charge.charge_amount }

      before do
        bucket.exemptions << bucket_exemptions
        order.bucket = bucket
      end

      context "with random charging details" do
        include_context "with bands and charges"
        include_context "with an order with exemptions"

        let(:bucket_exemptions) do
          [
            build_list(:exemption, 3, band: band_1),
            build_list(:exemption, 3, band: band_2),
            build_list(:exemption, 3, band: band_3)
          ].flatten
        end
        let(:band_charges) { charge_details.band_charge_details }
        let(:total_compliance_charge_amount) do
          band_charges.sum { |bc| bc.initial_compliance_charge_amount + bc.additional_compliance_charge_amount }
        end

        context "when there are no farmer bucket exemptions in the order" do
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

          it { expect(band_charges[2].initial_compliance_charge_amount).to eq(band_3.initial_compliance_charge.charge_amount) }
          it { expect(band_charges[2].additional_compliance_charge_amount).to be_zero }

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

      # Ref RUBY-3049
      context "with specific charging scenarios" do
        # The "for charging scenarios" shared context defines bands with names such as "band_upper", "band_u1" etc.
        include_context "for charging scenarios"

        let(:bucket_exemptions) { [exemption_U1, exemption_U4, exemption_U8, exemption_U10] }

        before { bucket.initial_compliance_charge.update(charge_amount: 9_000) }

        # scenario 6
        context "when a farmer registers multiple exemptions from multiple bands + exemptions in the farmers bucket" do
          let(:exemptions) { [exemption_U1, exemption_U4, exemption_U8, exemption_U10, exemption_T2, exemption_T8] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }

          it { expect(band_charges_upper.initial_compliance_charge_amount).to eq band_costs_pence[:upper][0] }
          it { expect(band_charges_upper.additional_compliance_charge_amount).to be_zero }

          it { expect(band_charges_u1.initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to be_zero }

          it { expect(band_charges_u2.initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges_u2.additional_compliance_charge_amount).to eq band_costs_pence[:u2][1] }

          it { expect(band_charges_u3).to be_nil }

          it { expect(charge_details.bucket_charge_amount).to eq farmers_bucket_charge_amount }

          it { expect(charge_details.total_charge_amount).to eq 138_500 }
        end

        # scenario 7
        context "when a farmer registers multiple exemptions all in the farmers bucket" do
          let(:exemptions) { [exemption_U1, exemption_U4, exemption_U8, exemption_U10] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }

          it { expect(band_charges_upper).to be_nil }

          it { expect(band_charges_u1.initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to be_zero }

          it { expect(band_charges_u2.initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges_u2.additional_compliance_charge_amount).to be_zero }

          it { expect(band_charges_u3).to be_nil }

          it { expect(charge_details.bucket_charge_amount).to eq farmers_bucket_charge_amount }

          it { expect(charge_details.total_charge_amount).to eq 13_100 }
        end
      end
    end
  end
end
