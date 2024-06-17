# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine

  RSpec.describe OrderCalculator do
    include_context "with bands and charges"
    include_context "with an order with exemptions"

    subject(:calculator) { described_class.new(strategy: RegularChargingStrategy, order:) }
    let(:order) { build(:order, exemptions:) }

    let(:exemptions) { multiple_bands_multiple_exemptions }

    describe "#registration_charge_amount" do
      context "with an empty order" do
        let(:exemptions) { [] }

        it { expect(calculator.registration_charge_amount).to be_zero }
      end

      context "with an order with a single exemption" do
        let(:exemptions) { single_band_single_exemption }

        it { expect(calculator.registration_charge_amount).to eq registration_charge_amount }
      end

      context "with an order with multiple exemptions in multiple bands" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it { expect(calculator.registration_charge_amount).to eq registration_charge_amount }
      end
    end

    describe "#band_charge_details" do
      context "with an empty order" do
        let(:exemptions) { [] }

        it { expect(calculator.band_charge_details).to be_empty }
      end

      context "with an order with a single exemption" do
        let(:exemptions) { single_band_single_exemption }

        it do
          band_detail = calculator.band_charge_details.first
          aggregate_failures do
            expect(band_detail.band_id).to eq band_1.id
            expect(band_detail.initial_compliance_charge_amount).to eq band_1.initial_compliance_charge.charge_amount
            expect(band_detail.additional_compliance_charge_amount).to be_zero
          end
        end
      end

      context "with an order with exemptions in multiple bands" do
        let(:exemptions) { multiple_bands_multiple_exemptions }
        let(:band_details) { calculator.band_charge_details }
        let(:band_1_details) { band_details.select { |b| b.band_id == band_1.id }.first }
        let(:band_2_details) { band_details.select { |b| b.band_id == band_2.id }.first }
        let(:band_3_details) { band_details.select { |b| b.band_id == band_3.id }.first }

        it do
          aggregate_failures do
            expect(band_1_details.initial_compliance_charge_amount).to be_zero
            expect(band_1_details.additional_compliance_charge_amount).to eq(
              3 * band_1.additional_compliance_charge.charge_amount
            )

            expect(band_2_details.initial_compliance_charge_amount).to be_zero
            expect(band_2_details.additional_compliance_charge_amount).to eq(
              2 * band_2.additional_compliance_charge.charge_amount
            )

            expect(band_3_details.initial_compliance_charge_amount).to eq(
              band_3.initial_compliance_charge.charge_amount
            )
            expect(band_3_details.additional_compliance_charge_amount).to be_zero
          end
        end
      end
    end

    describe "#total_compliance_charge_amount" do
      context "with an empty order" do
        let(:exemptions) { [] }

        it { expect(calculator.total_compliance_charge_amount).to be_zero }
      end

      context "with an order with a single exemption" do
        let(:exemptions) { single_band_single_exemption }

        it do
          expect(calculator.total_compliance_charge_amount).to eq(
            band_1.initial_compliance_charge.charge_amount
          )
        end
      end

      context "with an order with exemptions in multiple bands" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it do
          expect(calculator.total_compliance_charge_amount).to eq(
            (3 * band_1.additional_compliance_charge.charge_amount) +
            (2 * band_2.additional_compliance_charge.charge_amount) +
            band_3.initial_compliance_charge.charge_amount
          )
        end
      end
    end

    describe "#total_charge_amount" do
      context "with an empty order" do
        let(:exemptions) { [] }

        it { expect(calculator.total_charge_amount).to be_zero }
      end

      context "with an order with a single exemption" do
        let(:exemptions) { single_band_single_exemption }

        it do
          expect(calculator.total_charge_amount).to eq(
            registration_charge_amount +
            band_1.initial_compliance_charge.charge_amount
          )
        end
      end

      context "with an order with exemptions in multiple bands" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it do
          expect(calculator.total_charge_amount).to eq(
            registration_charge_amount +
            (3 * band_1.additional_compliance_charge.charge_amount) +
            (2 * band_2.additional_compliance_charge.charge_amount) +
            band_3.initial_compliance_charge.charge_amount
          )
        end
      end
    end

    describe "#charge_detail" do
      it { expect(calculator.charge_detail).to be_a(ChargeDetail) }
      it { expect(calculator.charge_detail.band_charge_details.length).to eq 3 }
    end
  end
end
