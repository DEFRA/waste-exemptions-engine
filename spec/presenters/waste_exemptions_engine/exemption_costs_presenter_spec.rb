# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ExemptionCostsPresenter do
    include_context "with bands and charges"
    include_context "with an order with exemptions"
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
