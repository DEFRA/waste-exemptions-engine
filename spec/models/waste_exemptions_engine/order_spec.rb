# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Order do

    describe "#highest_band" do
      subject(:highest_band) { described_class.new(exemptions:).highest_band }

      # rubocop:disable RSpec/IndexedLet
      let(:band_1) do
        build(:band,
              initial_compliance_charge: build(:charge, :initial_compliance_charge, charge_amount: 5),
              additional_compliance_charge: build(:charge, :additional_compliance_charge, charge_amount: 3))
      end
      let(:band_2) do
        build(:band,
              initial_compliance_charge: build(:charge, :initial_compliance_charge, charge_amount: 6),
              additional_compliance_charge: build(:charge, :additional_compliance_charge, charge_amount: 4))
      end
      let(:band_3) do
        build(:band,
              initial_compliance_charge: build(:charge, :initial_compliance_charge, charge_amount: 7),
              additional_compliance_charge: build(:charge, :additional_compliance_charge, charge_amount: 5))
      end
      # rubocop:enable RSpec/IndexedLet

      let(:exemptions) do
        [
          build(:exemption, band: band_1),
          build(:exemption, band: band_2),
          build(:exemption, band: band_3)
        ]
      end

      context "when the order has no exemptions" do
        let(:exemptions) { [] }

        it { expect(highest_band).to be_nil }
      end

      context "when the order has a single band 1 exemption" do
        let(:exemptions) { [build(:exemption, band: band_1)] }

        it { expect(highest_band).to eq band_1 }
      end

      context "when the order has a single band 3 exemption" do
        let(:exemptions) { [build(:exemption, band: band_3)] }

        it { expect(highest_band).to eq band_3 }
      end

      context "when the order has multiple exemptions from the same band" do
        let(:exemptions) do
          [
            build(:exemption, band: band_2),
            build(:exemption, band: band_2)
          ]
        end

        it { expect(highest_band).to eq band_2 }
      end

      context "when the order has multiple exemptions from different bands" do
        let(:exemptions) do
          [
            build(:exemption, band: band_1),
            build(:exemption, band: band_2)
          ]
        end

        it { expect(highest_band).to eq band_2 }
      end
    end

    describe "#bucket" do
      subject(:order_bucket) { described_class.new(bucket:).bucket }

      context "when the order has no bucket" do
        let(:bucket) { nil }

        it { expect(order_bucket).to be_nil }
      end

      context "when the order has a bucket" do
        let(:bucket) { create(:bucket) }

        it { expect(order_bucket).to eq bucket }
      end
    end

    # This method is sytactic sugar for bucket not nil.
    describe "#bucket?" do
      subject(:has_bucket) { described_class.new(exemptions: [], bucket:).bucket? }
      context "when the order does not include a bucket" do
        let(:bucket) { nil }

        it { expect(has_bucket).to be false }
      end

      context "when the order includes a bucket" do
        let(:bucket) { build(:bucket) }

        it { expect(has_bucket).to be true }
      end
    end

    describe "#order_uuid" do
      let(:transient_registration) { build(:new_charged_registration) }
      let(:order) { described_class.new(order_owner: transient_registration) }

      context "with no pre-existing uuid" do
        it "generates and saves a uuid" do
          expect(order[:order_uuid]).to be_nil
          expect(order.order_uuid).to be_present
          expect(order[:order_uuid]).to be_present
        end
      end

      context "with a pre-existing uuid" do
        it "returns the existing uuid" do
          uuid = order.order_uuid
          expect(order.order_uuid).to eq uuid
        end
      end
    end
  end
end
