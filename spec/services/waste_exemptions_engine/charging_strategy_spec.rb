# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine

  RSpec.describe ChargingStrategy do
    include_context "with bands and charges"
    include_context "with an order with exemptions"

    describe "#registration_charge" do
      subject(:strategy_registration_charge_amount) { described_class.new(order).registration_charge_amount }

      shared_examples "constant registration charge" do
        it { expect(strategy_registration_charge_amount).to eq registration_charge_amount }
      end

      context "with an empty order" do
        let(:exemptions) { [] }

        it { expect(strategy_registration_charge_amount).to be_zero }
      end

      context "with an order with a single exemption" do
        let(:exemptions) { single_band_single_exemption }

        it_behaves_like "constant registration charge"
      end

      context "with an order with multiple exemptions in a single band" do
        let(:exemptions) { single_band_multiple_exemptions }

        it_behaves_like "constant registration charge"
      end

      context "with an order with multiple exemptions in multiple bands" do
        let(:exemptions) { multiple_bands_multiple_exemptions }

        it_behaves_like "constant registration charge"
      end
    end

    describe "#charge_detail" do
      subject(:strategy) { described_class.new(order) }

      let(:exemptions) { multiple_bands_multiple_exemptions }

      it { expect(strategy.charge_detail).to be_a(ChargeDetail) }
      it { expect(strategy.charge_detail.registration_charge_amount).to eq registration_charge_amount }
      it { expect(strategy.charge_detail.band_charge_details.length).to eq 3 }
      it { expect(strategy.charge_detail.bucket_charge_amount).to be_zero }

      context "when order details are changed" do
        let(:new_exemption) { build(:exemption, band: Band.last) }

        it "returns a different result" do
          expect { order.exemptions << new_exemption }
            .to change { strategy.charge_detail.total_compliance_charge_amount }
            .by(new_exemption.band.additional_compliance_charge.charge_amount)
        end
      end
    end

    describe "#total_charge_amount" do
      subject(:strategy) { described_class.new(order) }

      let(:exemptions) { multiple_bands_multiple_exemptions }

      it do
        expect(strategy.total_charge_amount).to eq(
          strategy.registration_charge_amount +
          strategy.charge_detail.band_charge_details.sum do |bc|
            bc.initial_compliance_charge_amount + bc.additional_compliance_charge_amount
          end
        )
      end
    end

    describe "multisite charging" do
      subject(:strategy) { described_class.new(multisite_order) }

      let(:exemptions) { multiple_bands_multiple_exemptions }
      let(:site_count) { 3 }
      let(:transient_registration) { create(:new_charged_registration) }
      let(:order) { create(:order, exemptions: exemptions, order_owner: transient_registration) }

      let(:multisite_order) do
        create(:order,
               exemptions: exemptions,
               order_owner: create(:new_charged_registration, is_multisite_registration: true))
      end

      before do
        create_list(:transient_address, site_count, :site_address, transient_registration: multisite_order.order_owner)
      end

      describe "#charge_detail" do
        it "multiplies compliance charges by site count" do
          # Create a single site order for comparison
          single_site_order = create(:order,
                                     exemptions: exemptions,
                                     order_owner: create(:new_charged_registration))
          # Create exactly 1 site address for true single-site
          create(:transient_address, :site_address, transient_registration: single_site_order.order_owner)

          single_site_strategy = described_class.new(single_site_order)
          single_site_total = single_site_strategy.total_compliance_charge_amount
          multisite_total = strategy.total_compliance_charge_amount

          expect(multisite_total).to eq(single_site_total * site_count)
        end

        it "does not multiply registration charge by site count" do
          expect(strategy.registration_charge_amount).to eq(registration_charge_amount)
        end
      end

      context "with different site counts" do
        [1, 2, 5, 10].each do |count|
          context "with #{count} sites" do
            let(:site_count) { count }

            it "calculates compliance charges correctly" do
              # Create base single site order
              base_order = create(:order, exemptions: exemptions, order_owner: create(:new_charged_registration))
              # Create exactly 1 site address for true single-site
              create(:transient_address, :site_address, transient_registration: base_order.order_owner)

              base_strategy = described_class.new(base_order)
              base_compliance_charge = base_strategy.total_compliance_charge_amount

              expect(strategy.total_compliance_charge_amount).to eq(base_compliance_charge * count)
            end
          end
        end
      end

      context "when site_count is 0" do
        let(:strategy) { described_class.new(order) }

        it "does not return 0 for compliance charge" do
          expect(strategy.total_compliance_charge_amount).to be > 0
        end

        it "defaults to 1 and calculates charges correctly" do

          # Should equal single-site charges (multiplied by 1)
          single_site_order = create(:order,
                                     exemptions: exemptions,
                                     order_owner: create(:new_charged_registration))
          create(:transient_address, :site_address, transient_registration: single_site_order.order_owner)

          single_site_strategy = described_class.new(single_site_order)
          expect(strategy.total_compliance_charge_amount).to eq(single_site_strategy.total_compliance_charge_amount)
        end
      end
    end
  end
end
