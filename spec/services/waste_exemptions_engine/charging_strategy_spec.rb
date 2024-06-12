# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine

  RSpec.describe ChargingStrategy do
    include_context "with bands and charges"
    include_context "with an order with exemptions"

    # A subclass of described_class with the virtual methods implemented for test purposes:
    let(:strategy_test_class) do
      Class.new(described_class) do
        attr_reader :band_1, :band_2, :band_3

        def initialize(order)
          @band_1, @band_2, @band_3 = Band.all.limit(3).sort_by(&:sequence).to_a

          super
        end

        def initial_compliance_charge(band)
          band == highest_band ? band.initial_compliance_charge.charge_amount : 0
        end

        def additional_compliance_charge(band, _initial_compliance_charge_applied)
          band_exemptions = order.exemptions.select { |ex| ex.band == band }
          chargeable_count = band_exemptions.count - (band == highest_band ? 1 : 0)
          chargeable_count * band.additional_compliance_charge.charge_amount
        end
      end
    end

    describe "#registration_charge" do
      subject(:strategy_registration_charge_amount) { strategy_test_class.new(order).registration_charge_amount }

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

    describe "#charge_details" do
      subject(:strategy) { strategy_test_class.new(order) }

      let(:exemptions) { multiple_bands_multiple_exemptions }

      it { expect(strategy.charge_details).to be_a(ChargeDetail) }
      it { expect(strategy.charge_details.registration_charge_amount).to eq registration_charge_amount }
      it { expect(strategy.charge_details.band_charge_details.length).to eq 3 }
      it { expect(strategy.charge_details.bucket_charge_amount).to be_nil }

      it "does not persist the charge_detail" do
        expect { strategy.charge_details }.not_to change(ChargeDetail, :count)
      end

      it "does not persist the band_charge_details" do
        expect { strategy.charge_details }.not_to change(BandChargeDetail, :count)
      end

      context "when order details are changed" do
        let(:new_exemption) { build(:exemption, band: Band.last) }

        it "returns a different result" do
          expect { order.exemptions << new_exemption }
            .to change { strategy.charge_details.total_compliance_charge_amount }
            .by(new_exemption.band.additional_compliance_charge.charge_amount)
        end
      end
    end

    describe "#total_charge_amount" do
      subject(:strategy) { strategy_test_class.new(order) }

      let(:exemptions) { multiple_bands_multiple_exemptions }

      it do
        expect(strategy.total_charge_amount).to eq(
          strategy.registration_charge_amount +
          strategy.charge_details.band_charge_details.sum do |bc|
            bc.initial_compliance_charge_amount + bc.additional_compliance_charge_amount
          end
        )
      end
    end
  end
end
