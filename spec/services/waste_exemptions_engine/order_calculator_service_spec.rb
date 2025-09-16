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
    let(:expected_band_charges) do
      [
        build(:band_charge_detail, initial_compliance_charge_amount: 10, additional_compliance_charge_amount: 5),
        build(:band_charge_detail, initial_compliance_charge_amount: 15, additional_compliance_charge_amount: 12)
      ]
    end
    let(:expected_total_compliance_charge) do
      expected_band_charges.sum { |b| b.initial_compliance_charge_amount + b.additional_compliance_charge_amount }
    end
    let(:expected_total_charge) { expected_registration_charge + expected_total_compliance_charge }
    let(:charge_detail) { build(:charge_detail) }

    let(:calculator) do
      instance_double(OrderCalculator,
                      registration_charge_amount: expected_registration_charge,
                      band_charge_details: expected_band_charges,
                      total_compliance_charge_amount: expected_total_compliance_charge,
                      total_charge_amount: expected_total_charge,
                      charge_detail: charge_detail)
    end

    before { allow(OrderCalculator).to receive(:new).and_return(calculator) }

    describe "#strategy_type" do
      context "with an order without a bucket" do
        it "returns the regular charging strategy class" do
          expect(service.strategy_type).to eq(RegularChargingStrategy)
        end
      end

      context "with an order with a non-farmer bucket" do
        let(:bucket) { build(:bucket, name: "foo", bucket_type: "charity") }

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

      context "with a multisite registration" do
        let(:order) { build(:order, exemptions:, bucket:, order_owner: multisite_registration) }
        let(:multisite_registration) { create(:new_charged_registration, is_multisite_registration: true) }

        context "without a bucket" do
          it "returns the multisite charging strategy type" do
            expect(service.strategy_type).to eq(MultisiteChargingStrategy)
          end
        end

        context "with a non-farmer bucket" do
          let(:bucket) { build(:bucket, name: "foo", bucket_type: "charity") }

          it "returns the multisite charging strategy type" do
            expect(service.strategy_type).to eq(MultisiteChargingStrategy)
          end
        end

        context "with a farmer bucket" do
          let(:bucket) { build(:bucket, name: "Farmer exemptions") }

          it "returns the multisite farmer charging strategy type" do
            expect(service.strategy_type).to eq(MultisiteFarmerChargingStrategy)
          end
        end
      end

      context "with a non-multisite registration" do
        let(:order) { build(:order, exemptions:, bucket:, order_owner: regular_registration) }
        let(:regular_registration) { create(:new_charged_registration, is_multisite_registration: false) }

        context "with a farmer bucket" do
          let(:bucket) { build(:bucket, name: "Farmer exemptions") }

          it "returns the farmer charging strategy type" do
            expect(service.strategy_type).to eq(FarmerChargingStrategy)
          end
        end
      end
    end

    # These methods should all pass through to the calculator:

    describe "#registration_charge_amount" do
      it { expect(service.registration_charge_amount).to eq calculator.registration_charge_amount }
    end

    describe "#band_charge_details" do
      it { expect(service.band_charge_details).to eq calculator.band_charge_details }
    end

    describe "#total_compliance_charge_amount" do
      it { expect(service.total_compliance_charge_amount).to eq calculator.total_compliance_charge_amount }
    end

    describe "#total_charge_amount" do
      it { expect(service.total_charge_amount).to eq calculator.total_charge_amount }
    end

    describe "#charge_detail" do
      it { expect(service.charge_detail).to eq charge_detail }
    end
  end
end
