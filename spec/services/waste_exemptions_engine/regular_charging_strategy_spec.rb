# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegularChargingStrategy do

    describe "#charge_details" do
      context "with random charging details" do
        include_context "with bands and charges"
        include_context "with an order with exemptions"

        it_behaves_like "non-bucket charging strategy #charge_details"
      end

      # Ref RUBY-3049
      context "with specific charging scenarios" do
        include_context "for charging scenarios"

        # scenario 1
        context "when a sole trader registers for a single U1 exemption" do
          let(:exemptions) { [exemption_U1] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u1.initial_compliance_charge_amount).to eq band_costs_pence[:u1][0] }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to be_zero }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq 45_000 }
        end

        # scenario 2
        context "when a local authority registers for U9, T12, and S1 exemptions - multiple exemptions across a single band" do
          let(:exemptions) { [exemption_U9, exemption_T12, exemption_S1] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u1.initial_compliance_charge_amount).to eq band_costs_pence[:u1][0] }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to eq(2 * band_costs_pence[:u1][1]) }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq 59_800 }
        end

        # scenario 3
        context "when a limited company registers for T10, T12, T16, T28 exemptions - multiple exemptions across multiple bands" do
          let(:exemptions) { [exemption_T10, exemption_T12, exemption_T16, exemption_T28] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u1.initial_compliance_charge_amount).to eq band_costs_pence[:u1][0] }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to eq(band_costs_pence[:u1][1]) }
          it { expect(band_charges_u2.additional_compliance_charge_amount).to eq(band_costs_pence[:u2][1]) }
          it { expect(band_charges_u3.additional_compliance_charge_amount).to eq(band_costs_pence[:u3][1]) }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq 62_800 }
        end

        # scenario 4
        context "when a limited company registers for T8, S1, D1, D8 exemptions - multiple exemptions across multiple bands" do
          let(:exemptions) { [exemption_T8, exemption_S1, exemption_D1, exemption_D8] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_upper.initial_compliance_charge_amount).to eq band_costs_pence[:upper][0] }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to eq(band_costs_pence[:u1][1]) }
          it { expect(band_charges_u2.additional_compliance_charge_amount).to eq(band_costs_pence[:u2][1]) }
          it { expect(band_charges_u3.additional_compliance_charge_amount).to eq(band_costs_pence[:u3][1]) }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq 139_900 }
        end

        # scenario 5
        context "when a sole trader registers for a U3 exemption" do
          let(:exemptions) { [exemption_U3] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u3.initial_compliance_charge_amount).to eq band_costs_pence[:u3][0] }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq 7_100 }
        end
      end
    end
  end
end
