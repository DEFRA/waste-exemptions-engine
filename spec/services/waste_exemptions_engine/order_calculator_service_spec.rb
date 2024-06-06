# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OrderCalculatorService do
    include_context "with bands and charges"
    include_context "with an order with exemptions"

    subject(:service) { described_class.new(order) }

    let(:bucket) { nil }
    let(:exemptions) { multiple_bands_multiple_exemptions }
    let(:order) { build(:order, exemptions:, bucket:) }

    # The numbers here are just to suport stubbing the calculator methods - they are not internally consistent.
    # Validation of charge value consistency is covered in the OrderCalculator specs.
    let(:expected_registration_charge) { 5 }
    let(:expected_compliance_charges) do
      [
        build(:band_charge_detail, initial_compliance_charge_amount: 10, additional_compliance_charge_amount: 5),
        build(:band_charge_detail, initial_compliance_charge_amount: 15, additional_compliance_charge_amount: 12)
      ]
    end
    let(:expected_total_compliance_charge) do
      expected_compliance_charges.sum { |b| b.initial_compliance_charge_amount + b.additional_compliance_charge_amount }
    end
    let(:expected_total_charge) { expected_registration_charge + expected_total_compliance_charge }
    let(:charge_detail) { build(:charge_detail) }

    let(:calculator) do
      instance_double(OrderCalculator,
                      calculate_registration_charge: expected_registration_charge,
                      calculate_compliance_charges: expected_compliance_charges,
                      calculate_total_compliance_charge: expected_total_compliance_charge,
                      calculate_total_charge: expected_total_charge,
                      charge_details: charge_detail)
    end

    before { allow(OrderCalculator).to receive(:new).and_return(calculator) }

    describe "#strategy_type" do
      context "with an order without a bucket" do
        it "returns the regular charging strategy class" do
          expect(service.strategy_type).to eq(RegularChargingStrategy)
        end
      end

      context "with an order with a non-farmer bucket" do
        let(:bucket) { build(:bucket, name: "foo") }

        it "returns the regular charging strategy type" do
          expect(service.strategy_type).to eq(RegularChargingStrategy)
        end
      end

      context "with an order with a farmer bucket" do
        let(:bucket) { build(:bucket, name: "Farmer exemptions") }

        it "returns the farmer charging strategy type" do
          expect(service.strategy_type).to eq(FarmerChargingStrategy)
        end
      end
    end

    # These methods should all pass through to the calculator:

    describe "#calculate_registration_charge" do
      it { expect(service.calculate_registration_charge).to eq calculator.calculate_registration_charge }
    end

    describe "#calculate_compliance_charges" do
      it { expect(service.calculate_compliance_charges).to eq calculator.calculate_compliance_charges }
    end

    describe "#calculate_total_compliance_charge" do
      it { expect(service.calculate_total_compliance_charge).to eq calculator.calculate_total_compliance_charge }
    end

    describe "#calculate_total_charge" do
      it { expect(service.calculate_total_charge).to eq calculator.calculate_total_charge }
    end

    describe "#charge_details" do
      it { expect(service.charge_details).to eq charge_detail }
    end
  end
end
