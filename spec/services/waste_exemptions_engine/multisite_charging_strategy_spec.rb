# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe MultisiteChargingStrategy do
    let(:site_count) { 30 }

    before do
      order.order_owner = create(:new_charged_registration)
      order.save!
      create_list(:transient_address, site_count, :site_address, transient_registration: order.order_owner)
    end

    describe "#charge_details" do
      context "with multisite charging details" do
        include_context "with bands and charges"
        include_context "with an order with exemptions"

        # Equivalent to "non-bucket charging strategy #charge_details" shared examples
        # but modified to account for site_count multiplier on compliance charges
        subject(:charge_details) { described_class.new(order).charge_detail }

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
              expect(band_charges.first.initial_compliance_charge_amount).to eq(band_1.initial_compliance_charge.charge_amount * site_count)
              expect(band_charges.first.additional_compliance_charge_amount).to be_zero
              expect(band_charges.first.total_compliance_charge_amount).to eq(band_1.initial_compliance_charge.charge_amount * site_count)
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
          it { expect(band_charges[0].additional_compliance_charge_amount).to eq(3 * band_1.additional_compliance_charge.charge_amount * site_count) }

          it { expect(band_charges[1].initial_compliance_charge_amount).to be_zero }
          it { expect(band_charges[1].additional_compliance_charge_amount).to eq(2 * band_2.additional_compliance_charge.charge_amount * site_count) }

          it { expect(band_charges[2].initial_compliance_charge_amount).to eq(band_3.initial_compliance_charge.charge_amount * site_count) }
          it { expect(band_charges[2].additional_compliance_charge_amount).to be_zero }

          it { expect(charge_details.total_compliance_charge_amount).to eq total_compliance_charge_amount }
          it { expect(charge_details.total_charge_amount).to eq registration_charge_amount + total_compliance_charge_amount }
        end
      end

      # Ref RUBY-3049
      context "with specific charging scenarios" do
        include_context "for charging scenarios"

        # scenario 1
        context "when a sole trader registers for a single U1 exemption with multiple sites" do
          let(:exemptions) { [exemption_U1] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u1.initial_compliance_charge_amount).to eq(band_costs_pence[:u1][0] * site_count) }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to be_zero }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq(45_000 + (band_costs_pence[:u1][0] * (site_count - 1))) }
        end

        # scenario 2
        context "when a local authority registers for U9, T12, and S1 exemptions with multiple sites - multiple exemptions across a single band" do
          let(:exemptions) { [exemption_U9, exemption_T12, exemption_S1] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u1.initial_compliance_charge_amount).to eq(band_costs_pence[:u1][0] * site_count) }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to eq(2 * band_costs_pence[:u1][1] * site_count) }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq(59_800 + ((band_costs_pence[:u1][0] + (2 * band_costs_pence[:u1][1])) * (site_count - 1))) }
        end

        # scenario 3
        context "when a limited company registers for T10, T12, T16, T28 exemptions with multiple sites - multiple exemptions across multiple bands" do
          let(:exemptions) { [exemption_T10, exemption_T12, exemption_T16, exemption_T28] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u1.initial_compliance_charge_amount).to eq(band_costs_pence[:u1][0] * site_count) }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to eq(band_costs_pence[:u1][1] * site_count) }
          it { expect(band_charges_u2.additional_compliance_charge_amount).to eq(band_costs_pence[:u2][1] * site_count) }
          it { expect(band_charges_u3.additional_compliance_charge_amount).to eq(band_costs_pence[:u3][1] * site_count) }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq(62_800 + ((band_costs_pence[:u1][0] + band_costs_pence[:u1][1] + band_costs_pence[:u2][1] + band_costs_pence[:u3][1]) * (site_count - 1))) }
        end

        # scenario 4
        context "when a limited company registers for T8, S1, D1, D8 exemptions with multiple sites - multiple exemptions across multiple bands" do
          let(:exemptions) { [exemption_T8, exemption_S1, exemption_D1, exemption_D8] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_upper.initial_compliance_charge_amount).to eq(band_costs_pence[:upper][0] * site_count) }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to eq(band_costs_pence[:u1][1] * site_count) }
          it { expect(band_charges_u2.additional_compliance_charge_amount).to eq(band_costs_pence[:u2][1] * site_count) }
          it { expect(band_charges_u3.additional_compliance_charge_amount).to eq(band_costs_pence[:u3][1] * site_count) }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq(139_900 + ((band_costs_pence[:upper][0] + band_costs_pence[:u1][1] + band_costs_pence[:u2][1] + band_costs_pence[:u3][1]) * (site_count - 1))) }
        end

        # scenario 5
        context "when a sole trader registers for a U3 exemption with multiple sites" do
          let(:exemptions) { [exemption_U3] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u3.initial_compliance_charge_amount).to eq(band_costs_pence[:u3][0] * site_count) }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq(7_100 + (band_costs_pence[:u3][0] * (site_count - 1))) }
        end

        # scenario 6 - 30 sites test case
        context "when a registration has 30 sites" do
          let(:exemptions) { [exemption_U3] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u3.initial_compliance_charge_amount).to eq(band_costs_pence[:u3][0] * site_count) }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq(registration_charge_amount + (band_costs_pence[:u3][0] * site_count)) }
        end

        context "when a registration has 30 sites with multiple exemptions across multiple bands" do
          let(:exemptions) { [exemption_T10, exemption_T12, exemption_T16, exemption_T28] }

          it { expect(charge_details.registration_charge_amount).to eq(registration_charge_amount) }
          it { expect(band_charges_u1.initial_compliance_charge_amount).to eq(band_costs_pence[:u1][0] * site_count) }
          it { expect(band_charges_u1.additional_compliance_charge_amount).to eq(band_costs_pence[:u1][1] * site_count) }
          it { expect(band_charges_u2.additional_compliance_charge_amount).to eq(band_costs_pence[:u2][1] * site_count) }
          it { expect(band_charges_u3.additional_compliance_charge_amount).to eq(band_costs_pence[:u3][1] * site_count) }
          it { expect(charge_details.bucket_charge_amount).to be_zero }
          it { expect(charge_details.total_charge_amount).to eq(registration_charge_amount + ((band_costs_pence[:u1][0] + band_costs_pence[:u1][1] + band_costs_pence[:u2][1] + band_costs_pence[:u3][1]) * site_count)) }
        end
      end
    end
  end
end
