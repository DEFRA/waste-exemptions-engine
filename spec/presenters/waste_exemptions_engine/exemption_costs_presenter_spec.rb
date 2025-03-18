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

    describe "#band" do
      let(:exemptions) { [Bucket.farmer_bucket.exemptions.last] }

      context "when the exemption is part of a farmer bucket" do
        before { order.update(bucket: Bucket.farmer_bucket) }

        it { expect(presenter.band(exemptions[0])).to eq("not applicable") }
      end

      context "when the exemption belongs to most expensive band" do
        before { exemptions[0].band = band_3 }

        it { expect(presenter.band(exemptions[0])).to eq("Upper") }
      end

      context "when the exemption is not part of a farmer bucket and does not belong to most expensive band" do
        before do
          exemptions[0].band = band_2
          order.update(bucket: nil)
        end

        it { expect(presenter.band(exemptions[0])).to eq(exemptions[0].band.sequence) }
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

          it "returns blank for additional bucket exemptions" do
            expect(presenter.compliance_charge(bucket_exemption_low)).to eq("not applicable")
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

          it "returns blank for additional bucket exemptions" do
            expect(presenter.compliance_charge(bucket_exemption_low)).to eq("not applicable")
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

        it "returns blank for the rest of the farm exemptions" do
          order.exemptions[1..].each do |exemption|
            expect(presenter.compliance_charge(exemption)).to eq "not applicable"
          end
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

    describe "#charge_type" do
      context "with an exemption in the highest band" do
        let(:exemptions) { [create(:exemption, band: band_3)] }

        it "returns 'Full'" do
          exemption = exemptions.first
          expect(presenter.charge_type(exemption)).to eq("Full")
        end
      end

      context "with mixed bucket and non-bucket exemptions" do
        let(:bucket_exemption_high) { create(:exemption, band: band_3) }
        let(:bucket_exemption_low) { create(:exemption, band: band_1) }
        let(:first_non_bucket_high) { create(:exemption, band: band_3) }
        let(:second_non_bucket_high) { create(:exemption, band: band_3) }
        let(:non_bucket_low) { create(:exemption, band: band_1) }

        before do
          Bucket.farmer_bucket.exemptions = [bucket_exemption_high, bucket_exemption_low]
        end

        context "when bucket exemption is first in order" do
          let(:exemptions) { [bucket_exemption_high, first_non_bucket_high, second_non_bucket_high, bucket_exemption_low, non_bucket_low] }

          before do
            order.update(bucket: Bucket.farmer_bucket)
            order.exemptions = exemptions
          end

          it "returns 'Farming exemption' for first bucket exemption" do
            expect(presenter.charge_type(bucket_exemption_high)).to eq("Farming exemption")
          end

          it "returns 'Farming exemption' for additional bucket exemptions" do
            expect(presenter.charge_type(bucket_exemption_low)).to eq("Farming exemption")
          end

          it "returns 'Full' for first non-bucket exemption in highest band" do
            expect(presenter.charge_type(first_non_bucket_high)).to eq("Full")
          end

          it "returns 'Discounted' for additional non-bucket exemption in highest band" do
            expect(presenter.charge_type(second_non_bucket_high)).to eq("Discounted")
          end

          it "returns 'No discount' for non-bucket exemption in lower band" do
            expect(presenter.charge_type(non_bucket_low)).to eq("No discount")
          end
        end

        context "when non-bucket exemption is first in order" do
          let(:exemptions) { [first_non_bucket_high, bucket_exemption_high, second_non_bucket_high, bucket_exemption_low, non_bucket_low] }

          before do
            order.update(bucket: Bucket.farmer_bucket)
            order.exemptions = exemptions
          end

          it "returns 'Farming exemption' for first bucket exemption" do
            expect(presenter.charge_type(bucket_exemption_high)).to eq("Farming exemption")
          end

          it "returns 'Farming exemption' for additional bucket exemptions" do
            expect(presenter.charge_type(bucket_exemption_low)).to eq("Farming exemption")
          end

          it "returns 'Full' for first non-bucket exemption in highest band" do
            expect(presenter.charge_type(first_non_bucket_high)).to eq("Full")
          end

          it "returns 'Discounted' for additional non-bucket exemption in highest band" do
            expect(presenter.charge_type(second_non_bucket_high)).to eq("Discounted")
          end

          it "returns 'No discount' for non-bucket exemption in lower band" do
            expect(presenter.charge_type(non_bucket_low)).to eq("No discount")
          end
        end
      end

      context "with an exemption in a lower band" do
        let(:exemptions) { [create(:exemption, band: band_1), create(:exemption, band: band_3)] }

        it "returns 'No discount'" do
          exemption = exemptions.first
          expect(presenter.charge_type(exemption)).to eq("No discount")
        end

        context "with multiple exemptions including same highest band" do
          include_context "with multiple exemptions including same highest band"

          it "returns 'Full' for the first exemption in the highest band" do
            expect(presenter.charge_type(exemptions[0])).to eq("Full")
          end

          it "returns 'Discounted' for the second exemption in the highest band" do
            expect(presenter.charge_type(exemptions[1])).to eq("Discounted")
          end

          it "returns 'Discounted' for the exemption in the middle band" do
            expect(presenter.charge_type(exemptions[2])).to eq("Discounted")
          end

          it "returns 'Discounted' for the exemption in the lowest band" do
            expect(presenter.charge_type(exemptions[3])).to eq("Discounted")
          end
        end

        context "with an exemption from the farmer bucket" do
          let(:order) { CreateOrUpdateOrderService.run(transient_registration:) }
          let(:exemption) { Bucket.farmer_bucket.exemptions.first }

          context "when the transient registration is not farm_affiliated" do
            let(:transient_registration) { create(:new_charged_registration, on_a_farm: false) }

            it { expect(presenter.charge_type(exemption)).not_to eq("Farming exemption") }
          end

          context "when the transient registration is farm_affiliated" do
            let(:transient_registration) { create(:new_charged_registration, :farm_affiliated) }

            it { expect(presenter.charge_type(exemption)).to eq("Farming exemption") }
          end
        end
      end

      context "with an exemption in a band with no discounts (cheapest band)" do
        let(:exemptions) { 2.times.map { create(:exemption, band: band_1) } }

        it "returns 'No discount' for the first band exemption" do
          expect(presenter.charge_type(exemptions.first)).to eq("No discount")
        end

        it "returns 'No discount' for the non-first band exemption" do
          expect(presenter.charge_type(exemptions.second)).to eq("No discount")
        end
      end

      context "with an exemption in a band with no charge" do
        let(:no_charge_band) { create(:band, initial_compliance_charge: create(:charge, charge_amount: 0), additional_compliance_charge: create(:charge, charge_amount: 0)) }
        let(:no_charge_exemption) { create(:exemption, band: no_charge_band) }
        let(:charged_exemption) { create(:exemption, band: band_1) }
        let(:exemptions) { [no_charge_exemption, charged_exemption] }

        it "returns 'not applicable'" do
          expect(presenter.charge_type(no_charge_exemption)).to eq("not applicable")
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
  end
end
