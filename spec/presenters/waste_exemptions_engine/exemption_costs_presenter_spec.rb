# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
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

        it { expect(presenter.band(exemptions[0])).to eq("N/A") }
      end

      context "when the exemption is not part of a farmer bucket" do
        before { order.update(bucket: nil) }

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
      end

      context "when the order includes the farm bucket" do

        let(:exemptions) { Bucket.farmer_bucket.exemptions }

        before do
          Bucket.farmer_bucket.initial_compliance_charge.update(charge_amount: 9876)
          order.bucket = Bucket.farmer_bucket
          # exclude the first bucket exemption to test the first-bucket-exemption-in-the-order logic
          order.exemptions = Bucket.farmer_bucket.exemptions[1..]
          order.order_calculator
        end

        it "returns the bucket compliance charge for the first farm exemption in the order" do
          first_bucket_exemption = order.exemptions.first
          expect(presenter.compliance_charge(first_bucket_exemption)).to eq("£0.39")
        end

        it "returns blank for the rest of the farm exemptions" do
          order.exemptions[1..].each do |exemption|
            expect(presenter.compliance_charge(exemption)).to be_blank
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

      context "with an exemption in a lower band" do
        let(:exemptions) { [create(:exemption, band: band_1), create(:exemption, band: band_3)] }

        it "returns 'Discounted'" do
          exemption = exemptions.first
          expect(presenter.charge_type(exemption)).to eq("Discounted")
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

            it { expect(presenter.charge_type(exemption)).not_to eq("Farmer exemptions") }
          end

          context "when the transient registration is farm_affiliated" do
            let(:transient_registration) { create(:new_charged_registration, :farm_affiliated) }

            it { expect(presenter.charge_type(exemption)).to eq("Farmer exemptions") }
          end
        end
      end

      context "with an exemption in a band with no charge" do
        let(:no_charge_band) { create(:band, initial_compliance_charge: create(:charge, charge_amount: 0), additional_compliance_charge: create(:charge, charge_amount: 0)) }
        let(:no_charge_exemption) { create(:exemption, band: no_charge_band) }
        let(:charged_exemption) { create(:exemption, band: band_1) }
        let(:exemptions) { [no_charge_exemption, charged_exemption] }

        it "returns 'N/A'" do
          expect(presenter.charge_type(no_charge_exemption)).to eq("N/A")
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
  end
end
