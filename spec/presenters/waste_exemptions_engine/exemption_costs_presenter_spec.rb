# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine

  class SortableTest
    include CanSortExemptions
  end

  RSpec.describe ExemptionCostsPresenter do
    include_context "with bands and charges"
    include_context "with an order with exemptions"
    include_context "farm bucket"

    let(:order_calculator) { WasteExemptionsEngine::OrderCalculatorService.new(order) }

    subject(:presenter) { described_class.new(order: order) }

    describe "#exemptions" do
      context "with an empty order" do
        let(:exemptions) { [] }

        it "returns an empty array" do
          expect(presenter.exemptions).to be_empty
        end
      end

      context "with an order with multiple exemptions" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it "returns exemptions sorted by band sequence" do
          sorted_exemptions = exemptions.sort_by { |exemption| exemption.band.sequence }
          expect(presenter.exemptions.map(&:code)).to match_array(sorted_exemptions.map(&:code))
        end
      end
    end

    describe "#compliance_charge" do
      context "with an exemption in the highest band" do
        let(:exemptions) { [create(:exemption, band: band_3)] }

        it "returns the initial compliance charge" do
          exemption = exemptions.first
          expect(presenter.compliance_charge(exemption)).to eq("£#{format('%.2f', band_3.initial_compliance_charge.charge_amount_in_pounds)}")
        end
      end

      context "with mixed bucket and non-bucket exemptions" do
        let(:bucket_exemption_high) { create(:exemption, band: band_3) }
        let(:bucket_exemption_low) { create(:exemption, band: band_1) }
        let(:first_non_bucket_high) { create(:exemption, band: band_3) }
        let(:second_non_bucket_high) { create(:exemption, band: band_3) }
        let(:non_bucket_low) { create(:exemption, band: band_1) }

        context "when bucket exemption is first in order" do
          let(:exemptions) { [bucket_exemption_high, first_non_bucket_high, second_non_bucket_high, bucket_exemption_low, non_bucket_low] }

          before do
            # Add exemptions to the farmer bucket
            Bucket.farmer_bucket.exemptions = [bucket_exemption_high, bucket_exemption_low]
            order.update(bucket: Bucket.farmer_bucket)
            order.exemptions = exemptions
          end

          it "returns bucket charge for first bucket exemption" do
            expect(presenter.compliance_charge(bucket_exemption_high)).to eq("£#{format('%.2f', order_calculator.bucket_charge_amount / 100.0)}")
          end

          it "returns full charge for first non-bucket exemption in highest band" do
            expect(presenter.compliance_charge(first_non_bucket_high)).to eq("£#{format('%.2f', band_3.initial_compliance_charge.charge_amount_in_pounds)}")
          end

          it "returns reduced charge for additional non-bucket exemption in highest band" do
            expect(presenter.compliance_charge(second_non_bucket_high)).to eq("£#{format('%.2f', band_3.additional_compliance_charge.charge_amount_in_pounds)}")
          end

          it "returns reduced charge for non-bucket exemption in lower band" do
            expect(presenter.compliance_charge(non_bucket_low)).to eq("£#{format('%.2f', band_1.additional_compliance_charge.charge_amount_in_pounds)}")
          end
        end

        context "when non-bucket exemption is first in order" do
          let(:exemptions) { [first_non_bucket_high, bucket_exemption_high, second_non_bucket_high, bucket_exemption_low, non_bucket_low] }

          before do
            # Add exemptions to the farmer bucket
            Bucket.farmer_bucket.exemptions = [bucket_exemption_high, bucket_exemption_low]
            order.update(bucket: Bucket.farmer_bucket)
            order.exemptions = exemptions
            # Set the bucket charge
            Bucket.farmer_bucket.initial_compliance_charge.update(charge_amount: 70_198)
          end

          it "returns bucket charge for first bucket exemption" do
            expect(presenter.compliance_charge(bucket_exemption_high)).to eq("£#{format('%.2f', order_calculator.bucket_charge_amount / 100.0)}")
          end

          it "returns full charge for first non-bucket exemption in highest band" do
            expect(presenter.compliance_charge(first_non_bucket_high)).to eq("£#{format('%.2f', band_3.initial_compliance_charge.charge_amount_in_pounds)}")
          end

          it "returns reduced charge for additional non-bucket exemption in highest band" do
            expect(presenter.compliance_charge(second_non_bucket_high)).to eq("£#{format('%.2f', band_3.additional_compliance_charge.charge_amount_in_pounds)}")
          end

          it "returns reduced charge for non-bucket exemption in lower band" do
            expect(presenter.compliance_charge(non_bucket_low)).to eq("£#{format('%.2f', band_1.additional_compliance_charge.charge_amount_in_pounds)}")
          end
        end
      end

      context "with multiple exemptions including same highest band" do
        include_context "with multiple exemptions including same highest band"

        it "returns the correct charge for the highest band exemption" do
          expect(presenter.compliance_charge(exemptions[0])).to eq("£409.00")
        end

        it "returns the correct charge for the second exemption in the highest band" do
          expect(presenter.compliance_charge(exemptions[1])).to eq("£74.00")
        end

        it "returns the correct charge for the exemption in the middle band" do
          expect(presenter.compliance_charge(exemptions[2])).to eq("£74.00")
        end

        it "returns the correct charge for the exemption in the lowest band" do
          expect(presenter.compliance_charge(exemptions[3])).to eq("£30.00")
        end
      end

      context "when the order includes the farm bucket" do
        # Make the sequence of exemptions in the order different to the sequence in
        # the farm bucket to test "first sorted exemption" logic.
        let(:exemptions) { Bucket.farmer_bucket.exemptions[1..].reverse }
        let(:sorted_exemptions) { SortableTest.new.sorted_exemptions(exemptions) }

        before do
          Bucket.farmer_bucket.initial_compliance_charge.update(charge_amount: 9876)
          order.bucket = Bucket.farmer_bucket
          # exclude the first bucket exemption to test the first-bucket-exemption-in-the-order logic
          order.exemptions = Bucket.farmer_bucket.exemptions[1..]
          order.order_calculator
        end

        it "returns the bucket compliance charge for the first farm exemption in the order" do
          first_bucket_exemption = sorted_exemptions.first
          expect(presenter.compliance_charge(first_bucket_exemption)).to eq("£0.39")
        end
      end

      context "with an exemption in a lower band" do
        let(:exemptions) { [create(:exemption, band: band_1), create(:exemption, band: band_3)] }

        it "returns the additional compliance charge" do
          exemption = exemptions.first
          expect(presenter.compliance_charge(exemption)).to eq("£#{format('%.2f', band_1.additional_compliance_charge.charge_amount_in_pounds)}")
        end
      end

      context "with an exemption in a band with no charge" do
        let(:no_charge_band) { create(:band, initial_compliance_charge: create(:charge, charge_amount: 0), additional_compliance_charge: create(:charge, charge_amount: 0)) }
        let(:exemptions) { [create(:exemption, band: no_charge_band)] }

        it "returns £0.00" do
          exemption = exemptions.first
          expect(presenter.compliance_charge(exemption)).to eq("£0.00")
        end
      end
    end

    describe "#registration_charge" do
      let(:exemptions) { multiple_bands_multiple_exemptions }

      it "returns the formatted registration charge" do
        expect(presenter.registration_charge).to eq("£#{format('%.2f', order_calculator.registration_charge_amount / 100.0)}")
      end
    end

    describe "#total_compliance_charge" do
      let(:exemptions) { multiple_bands_multiple_exemptions }

      it "returns the formatted total compliance charge" do
        expect(presenter.total_compliance_charge).to eq("£#{format('%.2f', order_calculator.total_compliance_charge_amount / 100.0)}")
      end
    end

    describe "#total_charge" do
      context "with an empty order" do
        let(:exemptions) { [] }

        it "returns £0.00" do
          expect(presenter.total_charge).to eq("£0.00")
        end
      end

      context "with an order with multiple exemptions" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it "returns the total charge including registration and compliance charges" do
          expect(presenter.total_charge).to eq("£#{format('%.2f', order_calculator.total_charge_amount / 100.0)}")
        end
      end
    end

    describe "#farm_exemptions_selected?" do
      context "when the order has no exemptions" do
        let(:exemptions) { [] }

        it "returns false" do
          expect(presenter.farm_exemptions_selected?).to be(false)
        end
      end

      context "when the order has exemptions but none are from the farm bucket" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it "returns false" do
          expect(presenter.farm_exemptions_selected?).to be(false)
        end
      end

      context "when the order has exemptions from the farm bucket" do
        let(:exemptions) { [Bucket.farmer_bucket.exemptions.first] }

        before { order.update(bucket: Bucket.farmer_bucket) }

        it "returns true" do
          expect(presenter.farm_exemptions_selected?).to be(true)
        end
      end
    end

    describe "#farming_exemptions" do
      context "when the order has no farming exemptions" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it "returns empty array" do
          expect(presenter.farming_exemptions).to be_empty
        end
      end

      context "when the order has farming exemptions" do
        let(:first_farming_exemption) { Bucket.farmer_bucket.exemptions.first }
        let(:second_farming_exemption) { Bucket.farmer_bucket.exemptions.second }
        let(:non_farming_exemption) { create(:exemption, band: band_1) }
        let(:exemptions) { [first_farming_exemption, non_farming_exemption, second_farming_exemption] }

        before { order.update(bucket: Bucket.farmer_bucket) }

        it "returns only farming exemptions" do
          expect(presenter.farming_exemptions).to contain_exactly(first_farming_exemption, second_farming_exemption)
        end
      end
    end

    describe "#non_farming_exemptions" do
      context "when the order has no non-farming exemptions" do
        let(:exemptions) { [Bucket.farmer_bucket.exemptions.first] }

        before { order.update(bucket: Bucket.farmer_bucket) }

        it "returns empty array" do
          expect(presenter.non_farming_exemptions).to be_empty
        end
      end

      context "when the order has mixed exemptions" do
        let(:farming_exemption) { Bucket.farmer_bucket.exemptions.first }
        let(:first_non_farming_exemption) { create(:exemption, band: band_1) }
        let(:second_non_farming_exemption) { create(:exemption, band: band_2) }
        let(:exemptions) { [farming_exemption, first_non_farming_exemption, second_non_farming_exemption] }

        before { order.update(bucket: Bucket.farmer_bucket) }

        it "returns only non-farming exemptions" do
          expect(presenter.non_farming_exemptions).to contain_exactly(first_non_farming_exemption, second_non_farming_exemption)
        end
      end
    end

    describe "#farming_exemptions_codes" do
      context "when there are no farming exemptions" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it "returns empty string" do
          expect(presenter.farming_exemptions_codes).to eq("")
        end
      end

      context "when there are farming exemptions" do
        let(:first_farming_exemption) { Bucket.farmer_bucket.exemptions.first }
        let(:second_farming_exemption) { Bucket.farmer_bucket.exemptions.second }
        let(:exemptions) { [first_farming_exemption, second_farming_exemption] }

        before { order.update(bucket: Bucket.farmer_bucket) }

        it "returns comma-separated codes" do
          # The codes will be sorted by the presenter's exemptions method
          sorted_codes = presenter.farming_exemptions.map(&:code).join(", ")
          expect(presenter.farming_exemptions_codes).to eq(sorted_codes)
        end
      end
    end

    describe "#farming_exemptions_charge" do
      context "when there are no farming exemptions" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it "returns £0.00" do
          expect(presenter.farming_exemptions_charge).to eq("£0.00")
        end
      end

      context "when there are farming exemptions" do
        let(:farming_exemption) { Bucket.farmer_bucket.exemptions.first }
        let(:exemptions) { [farming_exemption] }

        before do
          order.update(bucket: Bucket.farmer_bucket)
          order.exemptions = exemptions
          # Mock the order calculator service to return the expected charge
          calculator_service = instance_double(WasteExemptionsEngine::OrderCalculatorService)
          allow(calculator_service).to receive(:bucket_charge_amount).and_return(8800) # £88.00 in pence
          allow(WasteExemptionsEngine::OrderCalculatorService).to receive(:new).and_return(calculator_service)
        end

        it "returns the bucket charge for farming exemptions" do
          expect(presenter.farming_exemptions_charge).to eq("£88.00")
        end
      end
    end

    describe "#farming_exemptions_single_site_charge" do
      context "when there are no farming exemptions" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it "returns £0.00" do
          expect(presenter.farming_exemptions_single_site_charge).to eq("£0.00")
        end
      end

      context "when there are farming exemptions" do
        let(:exemptions) { [Bucket.farmer_bucket.exemptions.first] }

        before do
          order.update(bucket: Bucket.farmer_bucket)
        end

        it "returns the single-site bucket charge for farming exemptions" do
          # Calculate the expected single-site farmer bucket charge
          single_site_calculator = WasteExemptionsEngine::OrderCalculator.new(
            order: order,
            strategy_type: WasteExemptionsEngine::FarmerChargingStrategy
          )
          expected_charge = ActionController::Base.helpers.number_to_currency(
            WasteExemptionsEngine::CurrencyConversionService
            .convert_pence_to_pounds(single_site_calculator.bucket_charge_amount),
            unit: "£"
          )

          expect(presenter.farming_exemptions_single_site_charge).to eq(expected_charge)
        end
      end
    end

    describe "#exemption_title_with_band" do
      let(:band) { create(:band, name: "Band 1") }
      let(:exemption) { create(:exemption, code: "S2", summary: "storing waste in a secure place", band: band) }
      let(:exemptions) { [exemption] }

      context "when exemption has a band" do
        it "returns the exemption title with band number" do
          expect(presenter.exemption_title_with_band(exemption)).to eq("S2 Storing waste in a secure place (band 1)")
        end
      end

      context "when exemption has no band" do
        before { exemption.band = nil }

        it "returns the exemption title without band number" do
          expect(presenter.exemption_title_with_band(exemption)).to eq("S2 Storing waste in a secure place")
        end
      end
    end

    describe "#is_discounted_charge?" do
      context "when exemption is in a bucket" do
        let(:exemptions) { [Bucket.farmer_bucket.exemptions.first] }

        before { order.update(bucket: Bucket.farmer_bucket) }

        it "returns false" do
          expect(presenter.is_discounted_charge?(exemptions.first)).to be(false)
        end
      end

      context "when exemption is the first in the highest band" do
        let(:exemptions) { [create(:exemption, band: band_3)] }

        it "returns false" do
          expect(presenter.is_discounted_charge?(exemptions.first)).to be(false)
        end
      end

      context "when exemption uses additional compliance charge" do
        let(:first_exemption) { create(:exemption, band: band_3) }
        let(:second_exemption) { create(:exemption, band: band_3) }
        let(:exemptions) { [first_exemption, second_exemption] }

        it "returns true for the second exemption" do
          expect(presenter.is_discounted_charge?(second_exemption)).to be(true)
        end

        it "returns false for the first exemption" do
          expect(presenter.is_discounted_charge?(first_exemption)).to be(false)
        end
      end

      context "when exemption is in a lower band" do
        let(:high_band_exemption) { create(:exemption, band: band_3) }
        let(:low_band_exemption) { create(:exemption, band: band_1) }
        let(:exemptions) { [high_band_exemption, low_band_exemption] }

        it "returns true for the lower band exemption" do
          expect(presenter.is_discounted_charge?(low_band_exemption)).to be(true)
        end
      end
    end

  end
end
