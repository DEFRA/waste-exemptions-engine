# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Bucket do
    describe "public interface" do
      subject(:bucket) { build(:bucket) }

      Helpers::ModelProperties::BUCKET.each do |property|
        it "responds to property" do
          expect(bucket).to respond_to(property)
        end
      end

      context "when initial_compliance_charge set" do
        let(:charge) { build(:charge, :initial_compliance_charge, charge_amount: 100) }
        let(:bucket) { build(:bucket, initial_compliance_charge: charge) }

        it "responds to initial_compliance_charge" do
          expect(bucket.initial_compliance_charge).to be_present
        end

        it "has charge_type set to initial_compliance_charge" do
          expect(bucket.initial_compliance_charge.charge_type).to eq("initial_compliance_charge")
        end

        it "has charge_amount set to 100" do
          expect(bucket.initial_compliance_charge.charge_amount).to eq(100)
        end
      end
    end
  end
end
