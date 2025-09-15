# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe MultisiteFarmerChargingStrategy do
    let(:site_count) { 30 }

    before do
      order.order_owner = create(:new_charged_registration)
      order.save!
      create_list(:transient_address, site_count, :site_address, transient_registration: order.order_owner)
    end

    describe "#charge_details" do
      subject(:charge_details) { described_class.new(order).charge_detail }

      let(:bucket) { create(:bucket) }
      let(:bucket_charge_amount) { bucket.initial_compliance_charge.charge_amount }

      before do
        bucket.exemptions << bucket_exemptions
        order.bucket = bucket
      end

      context "with multisite farmer charging details" do
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
          # Equivalent to "non-bucket charging strategy #charge_details" shared examples
          # but modified to account for site_count multiplier on compliance charges
          context "with an empty order" do
            let(:exemptions) { [] }

            it { expect(charge_details.registration_charge_amount).to be_zero }
            it { expect(band_charges).to be_empty }
            it { expect(charge_details.total_compliance_charge_amount).to be_zero }
            it { expect(charge_details.total_charge_amount).to be_zero }
          end

          context "with an order with a single exemption" do
            let(:exemptions) { single_band_single_exemption }

            it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
            it { expect(band_charges.length).to eq 1 }

            it do
              aggregate_failures do
                expect(band_charges.first.initial_compliance_charge_amount).to eq(band_1.initial_compliance_charge.charge_amount * site_count)
                expect(band_charges.first.additional_compliance_charge_amount).to be_zero
                expect(band_charges.first.total_compliance_charge_amount).to eq(band_1.initial_compliance_charge.charge_amount * site_count)
              end
            end

            it { expect(charge_details.total_compliance_charge_amount).to eq total_compliance_charge_amount }
            it { expect(charge_details.total_charge_amount).to eq registration_charge_amount + total_compliance_charge_amount }
          end

          context "with an order with multiple exemptions in multiple bands" do
            let(:exemptions) { multiple_bands_multiple_exemptions }

            it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
            it { expect(band_charges.length).to eq 3 }

            it { expect(band_charges[0].initial_compliance_charge_amount).to be_zero }
            it { expect(band_charges[0].additional_compliance_charge_amount).to eq(3 * band_1.additional_compliance_charge.charge_amount * site_count) }

            it { expect(band_charges[1].initial_compliance_charge_amount).to be_zero }
            it { expect(band_charges[1].additional_compliance_charge_amount).to eq(2 * band_2.additional_compliance_charge.charge_amount * site_count) }

            it { expect(band_charges[2].initial_compliance_charge_amount).to eq(band_3.initial_compliance_charge.charge_amount * site_count) }
            it { expect(band_charges[2].additional_compliance_charge_amount).to be_zero }

            it { expect(charge_details.total_compliance_charge_amount).to eq total_compliance_charge_amount }
            it { expect(charge_details.total_charge_amount).to eq registration_charge_amount + total_compliance_charge_amount }
          end
        end

        context "with an order with bucket exemptions only" do
          let(:exemptions) { bucket_exemptions }

          context "when the total compliance charge amount is greater than the bucket charge" do
            before do
              band_1.initial_compliance_charge.update(charge_amount: bucket.initial_compliance_charge.charge_amount + 1)
            end

            it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }

            it { expect(band_charges.length).to eq 3 }
            it { expect(band_charges[0].initial_compliance_charge_amount).to be_zero }
            it { expect(band_charges[1].initial_compliance_charge_amount).to be_zero }
            it { expect(band_charges[2].initial_compliance_charge_amount).to be_zero }

            it { expect(charge_details.bucket_charge_amount).to eq(bucket_charge_amount * site_count) }

            it { expect(charge_details.total_compliance_charge_amount).to eq(bucket_charge_amount * site_count) }
            it { expect(charge_details.total_charge_amount).to eq(registration_charge_amount + (bucket_charge_amount * site_count)) }
          end

          context "when the total compliance charge amount is less than the bucket charge" do
            let(:exemptions) { [bucket_exemptions.first] }
            let(:exemption_band) { exemptions[0].band }
            let(:expected_total_compliance_charge_amount) { exemption_band.initial_compliance_charge.charge_amount * site_count }

            before do
              exemption_band.initial_compliance_charge.update(charge_amount: bucket.initial_compliance_charge.charge_amount - 1)
            end

            it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }

            it { expect(band_charges.length).to eq 1 }
            it { expect(band_charges[0].initial_compliance_charge_amount).to be_zero }

            it { expect(charge_details.bucket_charge_amount).to eq expected_total_compliance_charge_amount }

            it { expect(charge_details.total_compliance_charge_amount).to eq expected_total_compliance_charge_amount }
            it { expect(charge_details.total_charge_amount).to eq registration_charge_amount + expected_total_compliance_charge_amount }
          end
        end

        context "with an order with both bucket and non-bucket exemptions" do
          let(:exemptions) { bucket_exemptions + multiple_bands_multiple_exemptions }
          # Calculate the expected bucket charge as the lesser of:
          #   - the sum of the initial compliance charges for the bucket exemptions in the order (multiplied by site count)
          #   - the default bucket charge amount (multiplied by site count)
          let(:expected_bucket_charge_amount) do
            bucket_exemptions_in_order = exemptions.select { |ex| bucket.exemptions.include?(ex) }
            [bucket_exemptions_in_order.sum { |ex| ex.band.initial_compliance_charge.charge_amount }, bucket_charge_amount].min * site_count
          end

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }

          it { expect(band_charges.length).to eq 3 }
          it { expect(band_charges[0].initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges[0].additional_compliance_charge_amount).to eq(3 * band_1.additional_compliance_charge.charge_amount * site_count) }

          it { expect(band_charges[1].initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges[1].additional_compliance_charge_amount).to eq(2 * band_2.additional_compliance_charge.charge_amount * site_count) }

          it { expect(band_charges[2].initial_compliance_charge_amount).to eq(band_3.initial_compliance_charge.charge_amount * site_count) }
          it { expect(band_charges[2].additional_compliance_charge_amount).to be_zero }

          it { expect(charge_details.bucket_charge_amount).to eq expected_bucket_charge_amount }

          it do
            expect(charge_details.total_compliance_charge_amount).to eq(
              expected_bucket_charge_amount +
              band_charges.sum { |bc| bc.initial_compliance_charge_amount + bc.additional_compliance_charge_amount }
            )
          end

          it do
            expect(charge_details.total_charge_amount).to eq(
              registration_charge_amount +
              total_compliance_charge_amount +
              expected_bucket_charge_amount
            )
          end

          # Ref RUBY-3719 - multisite version
          context "when selected farming exemptions also belong to the highest band and selected non-farming exemptions do not belong to the highest band" do
            let(:exemptions) { [bucket_exemptions[6], multiple_bands_multiple_exemptions[3]] }
            let(:order) { create(:order, exemptions:) }
            let(:charge_details) { described_class.new(order).charge_detail }

            it "returns the expected amount" do
              expected_compliance_charge_amount = (exemptions[0].band.initial_compliance_charge.charge_amount + exemptions[1].band.initial_compliance_charge.charge_amount) * site_count
              expect(charge_details.total_compliance_charge_amount).to eq(expected_compliance_charge_amount)
            end
          end
        end
      end

      context "with specific multisite farmer charging scenarios" do
        # The "for charging scenarios" shared context defines bands with names such as "band_upper", "band_u1" etc.
        include_context "for charging scenarios"

        let(:bucket_exemptions) { [exemption_U1, exemption_U4, exemption_U8, exemption_U10] }
        let(:expected_farmers_bucket_charge_amount) do
          [bucket_exemptions.sum { |ex| ex.band.initial_compliance_charge.charge_amount }, farmers_bucket_charge_amount].min * site_count
        end

        before { bucket.initial_compliance_charge.update(charge_amount: 9_000) }

        # scenario 6 - multisite version
        context "when a farmer registers multiple exemptions from multiple bands + exemptions in the farmers bucket with multiple sites" do
          let(:exemptions) { [exemption_U1, exemption_U4, exemption_U8, exemption_U10, exemption_T2, exemption_T8] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }

          it { expect(band_charges_upper.initial_compliance_charge_amount).to eq(band_costs_pence[:upper][0] * site_count) }
          it { expect(band_charges_upper.additional_compliance_charge_amount).to be_zero }

          it { expect(band_charges_u1.initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to be_zero }

          it { expect(band_charges_u2.initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges_u2.additional_compliance_charge_amount).to eq(band_costs_pence[:u2][1] * site_count) }

          it { expect(band_charges_u3).to be_nil }

          it { expect(charge_details.bucket_charge_amount).to eq expected_farmers_bucket_charge_amount }

          it { expect(charge_details.total_charge_amount).to eq(registration_charge_amount + ((band_costs_pence[:upper][0] + band_costs_pence[:u2][1]) * site_count) + expected_farmers_bucket_charge_amount) }
        end

        # scenario 7 - multisite version
        context "when a farmer registers multiple exemptions all in the farmers bucket with multiple sites" do
          let(:exemptions) { [exemption_U1, exemption_U4, exemption_U8, exemption_U10] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }

          it { expect(band_charges_upper).to be_nil }

          it { expect(band_charges_u1.initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to be_zero }

          it { expect(band_charges_u2.initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges_u2.additional_compliance_charge_amount).to be_zero }

          it { expect(band_charges_u3).to be_nil }

          it { expect(charge_details.bucket_charge_amount).to eq expected_farmers_bucket_charge_amount }

          it { expect(charge_details.total_charge_amount).to eq(registration_charge_amount + expected_farmers_bucket_charge_amount) }
        end

        # Additional multisite-specific scenarios
        context "when a farmer has 30 sites with single exemption in bucket" do
          let(:exemptions) { [exemption_U1] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(charge_details.bucket_charge_amount).to eq(expected_farmers_bucket_charge_amount) }
          it { expect(charge_details.total_charge_amount).to eq(registration_charge_amount + expected_farmers_bucket_charge_amount) }
        end

        context "when a farmer has 30 sites with mixed bucket and non-bucket exemptions" do
          let(:exemptions) { [exemption_U1, exemption_U4, exemption_T10, exemption_T12] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u1.initial_compliance_charge_amount).to eq(band_costs_pence[:u1][0] * site_count) }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to eq(band_costs_pence[:u1][1] * site_count) }
          it { expect(charge_details.bucket_charge_amount).to eq expected_farmers_bucket_charge_amount }
          it { expect(charge_details.total_charge_amount).to eq(registration_charge_amount + ((band_costs_pence[:u1][0] + band_costs_pence[:u1][1]) * site_count) + expected_farmers_bucket_charge_amount) }
        end
      end
    end
  end
end
