# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Address do
    describe "public interface" do
      subject(:address) { build(:address) }

      associations = [:registration]

      (Helpers::ModelProperties::ADDRESS + associations).each do |property|
        it "responds to property" do
          expect(address).to respond_to(property)
        end
      end
    end

    describe "scopes" do
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

          expect(described_class.with_postcode).to contain_exactly(valid_address)
        end
      end

      describe ".with_valid_easting_and_northing" do
        it "returns all address with valid x and y information" do
          create(:address, x: nil, y: 123.4)
          create(:address, x: 123.4, y: nil)
          create(:address, x: 0.00, y: 0.00)

          valid_address = create(:address, x: 123.4, y: 123.4)

          expect(described_class.with_valid_easting_and_northing).to contain_exactly(valid_address)
        end
      end

      describe ".missing_area" do
        it "returns all addresses with a missing area" do
          missing_info_records = []
          missing_info_records << create(:address, area: nil)
          missing_info_records << create(:address, area: "")

          create(:address, area: "West Midlands")

          expect(described_class.missing_area).to match_array(missing_info_records)
        end
      end
    end

    describe "#located_by_grid_reference?" do
      subject(:site_address) { described_class.new(mode: mode, address_type: :site) }

      context "when mode is manual" do
        let(:mode) { :manual }

        it "returns false" do
          expect(site_address).not_to be_located_by_grid_reference
        end
      end

      context "when mode is auto" do
        let(:mode) { :auto }

        it "returns true" do
          expect(site_address).to be_located_by_grid_reference
        end
      end
    end
  end
end
