# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Band do
    describe "public interface" do
      subject(:band) { build(:band) }

      Helpers::ModelProperties::BAND.each do |property|
        it "responds to property" do
          expect(band).to respond_to(property)
        end
      end

      context "when initial_compliance_charge set" do
        let(:band) { create(:band, :no_charges) }
        let(:charge) { create(:charge, :initial_compliance_charge, charge_amount: 100, chargeable: band) }

        it "responds to initial_compliance_charge" do
          charge
          expect(band.reload.initial_compliance_charge).to be_present
        end

        it "has charge_type set to initial_compliance_charge" do
          charge
          expect(band.reload.initial_compliance_charge.charge_type).to eq("initial_compliance_charge")
        end

        it "has charge_amount set to 100" do
          charge
          expect(band.reload.initial_compliance_charge.charge_amount).to eq(100)
        end
      end

      context "when additional_compliance_charge set" do
        let(:band) { create(:band, :no_charges) }
        let(:charge) { create(:charge, :additional_compliance_charge, charge_amount: 100, chargeable: band) }

        it "responds to additional_compliance_charge" do
          charge
          expect(band.reload.additional_compliance_charge).to be_present
        end

        it "has charge_type set to additional_compliance_charge" do
          charge
          expect(band.reload.additional_compliance_charge.charge_type).to eq("additional_compliance_charge")
        end

        it "has charge_amount set to 100" do
          charge
          expect(band.reload.additional_compliance_charge.charge_amount).to eq(100)
        end
      end
    end
  end
end
