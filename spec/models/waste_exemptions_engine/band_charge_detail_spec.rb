# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BandChargeDetail do
    let(:band) { build(:band) }
    let(:band_charge_detail) { build(:band_charge_detail, band:) }

    describe "band" do
      it { expect(band_charge_detail).to respond_to(:band) }
    end

    describe "initial_compliance_charge_amount" do
      it { expect(band_charge_detail).to respond_to(:initial_compliance_charge_amount) }
    end

    describe "additional_compliance_charge_amount" do
      it { expect(band_charge_detail).to respond_to(:additional_compliance_charge_amount) }
    end

    describe "#total_compliance_charge_amount" do
      it do
        expect(band_charge_detail.total_compliance_charge_amount).to eq(
          band_charge_detail.initial_compliance_charge_amount +
          band_charge_detail.additional_compliance_charge_amount
        )
      end
    end
  end
end
