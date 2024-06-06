# frozen_string_literal: true

RSpec.shared_examples "non-bucket charging strategy #charge_details" do
  subject(:charge_details) { described_class.new(order).charge_details }

  let(:band_charges) { charge_details.band_charge_details }
  let(:total_compliance_charge_amount) do
    band_charges.sum { |bc| bc.initial_compliance_charge_amount + bc.additional_compliance_charge_amount }
  end

  context "with an empty order" do
    let(:exemptions) { [] }

    it { expect(charge_details.registration_charge_amount).to be_zero }
    it { expect(band_charges).to be_empty }
    it { expect(charge_details.total_compliance_charge_amount).to be_zero }
    it { expect(charge_details.total_charge_amount).to be_zero }
  end

  context "with an order with a single exemption" do
    let(:exemptions) { single_band_single_exemption }

    it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
    it { expect(band_charges.length).to eq 1 }

    it do
      aggregate_failures do
        expect(band_charges.first.initial_compliance_charge_amount).to eq(band_1.initial_compliance_charge.charge_amount)
        expect(band_charges.first.additional_compliance_charge_amount).to be_zero
        expect(band_charges.first.total_compliance_charge_amount).to eq(band_1.initial_compliance_charge.charge_amount)
      end
    end

    it { expect(charge_details.total_compliance_charge_amount).to eq total_compliance_charge_amount }
    it { expect(charge_details.total_charge_amount).to eq registration_charge_amount + total_compliance_charge_amount }
  end

  context "with an order with multiple exemptions in multiple bands" do
    let(:exemptions) { multiple_bands_multiple_exemptions }

    it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
    it { expect(band_charges.length).to eq 3 }

    it { expect(band_charges[0].initial_compliance_charge_amount).to be_zero }
    it { expect(band_charges[0].additional_compliance_charge_amount).to eq(3 * band_1.additional_compliance_charge.charge_amount) }

    it { expect(band_charges[1].initial_compliance_charge_amount).to be_zero }
    it { expect(band_charges[1].additional_compliance_charge_amount).to eq(2 * band_2.additional_compliance_charge.charge_amount) }

    it { expect(band_charges[2].initial_compliance_charge_amount).to eq(band_3.initial_compliance_charge.charge_amount) }
    it { expect(band_charges[2].additional_compliance_charge_amount).to be_zero }

    it { expect(charge_details.total_compliance_charge_amount).to eq total_compliance_charge_amount }
    it { expect(charge_details.total_charge_amount).to eq registration_charge_amount + total_compliance_charge_amount }
  end
end
