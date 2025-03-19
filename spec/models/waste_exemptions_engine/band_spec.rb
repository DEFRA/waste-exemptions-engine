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

      describe "callbacks" do
        context "when destroying a band" do
          context "when it has no exemptions" do
            it "destroys the band" do
              band = create(:band, :no_charges)
              band.destroy
              expect(described_class.exists?(band.id)).to be(false)
            end
          end

          context "when it has exemptions" do
            let(:band) { create(:band, :no_charges) }

            before do
              create(:exemption, band: band)
              band.destroy
            end

            it "does not destroy the band" do
              expect(described_class.exists?(band.id)).to be(true)
            end

            it "adds an error to the band" do
              expect(band.errors[:base]).to include("Cannot delete band while it has exemptions associated")
            end
          end
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

      describe "#can_be_destroyed" do
        context "when band has no exemptions" do
          it "returns true" do
            band = create(:band, :no_charges)
            expect(band.can_be_destroyed?).to be(true)
          end
        end

        context "when band has exemptions" do
          it "returns false" do
            band = create(:band, :no_charges)
            create(:exemption, band: band)
            expect(band.can_be_destroyed?).to be(false)
          end
        end
      end

      describe "#charged?" do
        context "when band charges are set to 0" do
          it "returns false" do
            initial_compliance_charge = create(:charge, :initial_compliance_charge, charge_amount: 0)
            additional_compliance_charge = create(:charge, :additional_compliance_charge, charge_amount: 0)
            band = create(:band, initial_compliance_charge: initial_compliance_charge, additional_compliance_charge: additional_compliance_charge)
            expect(band.charged?).to be(false)
          end
        end

        context "when band has charges" do
          it "returns true" do
            band = create(:band)
            expect(band.charged?).to be(true)
          end
        end
      end

      describe "#discount_possible?" do
        context "when initial_compliance_charge is greater than additional_compliance_charge" do
          it "returns true" do
            initial_compliance_charge = create(:charge, :initial_compliance_charge, charge_amount: 100)
            additional_compliance_charge = create(:charge, :additional_compliance_charge, charge_amount: 50)
            band = create(:band, initial_compliance_charge: initial_compliance_charge, additional_compliance_charge: additional_compliance_charge)
            expect(band.discount_possible?).to be(true)
          end
        end

        context "when initial_compliance_charge is same as additional_compliance_charge" do
          it "returns false" do
            initial_compliance_charge = create(:charge, :initial_compliance_charge, charge_amount: 100)
            additional_compliance_charge = create(:charge, :additional_compliance_charge, charge_amount: 100)
            band = create(:band, initial_compliance_charge: initial_compliance_charge, additional_compliance_charge: additional_compliance_charge)
            expect(band.discount_possible?).to be(false)
          end
        end
      end
    end
  end
end
