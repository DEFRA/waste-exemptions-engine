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
      before do
        # TODO: This is necessary as those tests are generating random failures due to
        # the database not being cleaned properly by some other test
        described_class.delete_all
      end

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

      describe ".with_postcode" do
        it "returns all address with a postcode" do
          create(:address, postcode: nil)
          create(:address, postcode: "")

          valid_address = create(:address, postcode: "BS1 5AH")

          expect(described_class.with_postcode.size).to eq(1)
          expect(described_class.with_postcode.first).to eq(valid_address)
        end
      end

      describe ".with_valid_easting_and_northing" do
        it "returns all address with valid x and y information" do
          create(:address, x: nil, y: 123.4)
          create(:address, x: 123.4, y: nil)
          create(:address, x: 0.00, y: 0.00)

          valid_address = create(:address, x: 123.4, y: 123.4)

          expect(described_class.with_valid_easting_and_northing.size).to eq(1)
          expect(described_class.with_valid_easting_and_northing.first).to eq(valid_address)
        end
      end

      describe ".missing_area" do
        it "returns all addresses with a missing area" do
          create(:address, area: "West Midlands")

          nil_area = create(:address, area: nil)
          empty_area = create(:address, area: "")

          expect(described_class.missing_area.size).to eq(2)
          expect(described_class.missing_area).to include(empty_area)
          expect(described_class.missing_area).to include(nil_area)
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
