# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientAddress, type: :model do
    subject(:transient_address) { build(:transient_address) }

    describe "public interface" do
      associations = [:transient_registration]

      (Helpers::ModelProperties::ADDRESS + associations).each do |property|
        it "responds to property" do
          expect(transient_address).to respond_to(property)
        end
      end
    end

    describe "#address_attributes" do
      it "returns attributes specific to defining an address" do
        attributes = transient_address.address_attributes
        expect(attributes.keys).to match_array(Helpers::ModelProperties::ADDRESS.map(&:to_s))
      end
    end

    describe ".create_from_address_finder_data" do
      let(:address_finder_data) do
        {
          "uprn" => 340_116,
          "address" => "NATURAL ENGLAND, HORIZON HOUSE, DEANERY ROAD, BRISTOL, BS1 5AH",
          "organisation" => "NATURAL ENGLAND",
          "premises" => "HORIZON HOUSE",
          "street_address" => "DEANERY ROAD",
          "locality" => nil,
          "city" => "BRISTOL",
          "postcode" => "BS1 5AH",
          "x" => "358205.03",
          "y" => "172708.07",
          "coordinate_system" => nil,
          "state_date" => "12/10/2009",
          "blpu_state_code" => nil,
          "postal_address_code" => nil,
          "logical_status_code" => nil,
          "source_data_type" => "dpa"
        }
      end
      let(:expectations) do
        {
          "uprn" => "340116",
          "organisation" => "NATURAL ENGLAND",
          "premises" => "HORIZON HOUSE",
          "street_address" => "DEANERY ROAD",
          "locality" => nil,
          "city" => "BRISTOL",
          "postcode" => "BS1 5AH",
          "x" => 358_205.03,
          "y" => 172_708.07,
          "coordinate_system" => nil,
          "blpu_state_code" => nil,
          "postal_address_code" => nil,
          "logical_status_code" => nil,
          "source_data_type" => "dpa"
        }
      end
      subject(:address) { described_class.create_from_address_finder_data(address_finder_data, 2) }

      it "creates an address from the address finder data" do
        expectations.keys.each do |property|
          expect(address.send(property)).to eq(expectations[property])
        end
      end
    end

    describe ".create_from_manual_entry_data" do
      let(:manual_address_data) do
        {
          premises: "Example House",
          street_address: "2 On The Road",
          locality: "Near Horizon House",
          city: "Bristol",
          postcode: "BS1 5AH"
        }
      end
      let(:address_type) { 2 }
      subject(:address) { described_class.create_from_manual_entry_data(manual_address_data, address_type) }

      it "creates an address from the given data" do
        manual_address_data.keys.each do |property|
          expect(address.send(property)).to eq(manual_address_data[property])
        end
      end

      context "when the address is a site address" do
        let(:address_type) { 3 }

        it "creates an address from the given data" do
          manual_address_data.keys.each do |property|
            expect(address.send(property)).to eq(manual_address_data[property])
          end
        end
      end
    end

    describe ".create_from_grid_reference_data" do
      let(:grid_reference_data) do
        {
          grid_reference: "ST 58337 72855",
          description: "The waste is stored in an out-building next to the barn."
        }
      end
      subject(:address) { described_class.create_from_manual_entry_data(grid_reference_data, 3) }

      it "creates an address from the grid reference" do
        grid_reference_data.keys.each do |property|
          expect(address.send(property)).to eq(grid_reference_data[property])
        end
      end
    end
  end
end
