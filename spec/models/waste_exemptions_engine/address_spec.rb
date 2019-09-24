# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Address, type: :model do
    describe "public interface" do
      subject(:address) { build(:address) }

      associations = [:registration]

      (Helpers::ModelProperties::ADDRESS + associations).each do |property|
        it "responds to property" do
          expect(address).to respond_to(property)
        end
      end
    end

    context "scopes" do
      describe ".missing_easting_or_northing" do
        it "returns all address with x and y information" do
          missing_info_records = []
          missing_info_records << create(:address, x: nil, y: 123.4)
          missing_info_records << create(:address, x: 123.4, y: nil)
          missing_info_records << create(:address, x: nil, y: nil)

          create(:address, x: 123.4, y: 123.4)

          expect(described_class.missing_easting_or_northing).to match_array(missing_info_records)
        end
      end
    end

    describe "#located_by_grid_reference?" do
      subject { described_class.new(mode: mode, address_type: :site) }

      context "when mode is manual" do
        let(:mode) { :manual }

        it "returns false" do
          expect(subject).to_not be_located_by_grid_reference
        end
      end

      context "when mode is auto" do
        let(:mode) { :auto }

        it "returns true" do
          expect(subject).to be_located_by_grid_reference
        end
      end
    end
  end
end
