# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ChargeDetail do
    let(:charge_detail) { build(:charge_detail) }
    let(:band_charges) { charge_detail.band_charge_details }
    let(:total_compliance_charge_amount) do
      band_charges.sum do |bc|
        bc.initial_compliance_charge_amount + bc.additional_compliance_charge_amount
      end
    end

    describe "#total_compliance_charge_amount" do
      it { expect(charge_detail.total_compliance_charge_amount).to eq total_compliance_charge_amount }
    end

    describe "#total_charge_amount" do
      it do
        expect(charge_detail.total_charge_amount).to eq(
          charge_detail.registration_charge_amount +
          total_compliance_charge_amount
        )
      end
    end
  end
end
