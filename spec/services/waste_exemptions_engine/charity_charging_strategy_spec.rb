# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CharityChargingStrategy do
    include_context "with bands and charges"
    include_context "with an order with exemptions"

    let(:exemptions) { multiple_bands_multiple_exemptions }
    let(:order) { create(:order, exemptions:) }

    subject(:strategy) { described_class.new(order) }

    describe "#registration_charge_amount" do
      it "returns 0" do
        expect(strategy.registration_charge_amount).to eq(0)
      end
    end

    describe "#only_no_charge_exemptions?" do
      it "returns true" do
        expect(strategy.only_no_charge_exemptions?).to be(true)
      end
    end

    describe "#base_bucket_charge_amount" do
      it "returns 0" do
        expect(strategy.base_bucket_charge_amount).to eq(0)
      end
    end

    describe "#charge_detail" do
      it "returns a charge detail with zero compliance charges" do
        charge_detail = strategy.charge_detail
        aggregate_failures do
          charge_detail.band_charge_details.each do |band_charge|
            expect(band_charge.initial_compliance_charge_amount).to eq(0)
            expect(band_charge.additional_compliance_charge_amount).to eq(0)
          end
        end
      end

      it "returns a total charge amount of zero" do
        expect(strategy.total_charge_amount).to eq(0)
      end

      it "returns a total compliance charge amount of zero" do
        expect(strategy.total_compliance_charge_amount).to eq(0)
      end
    end
  end
end
