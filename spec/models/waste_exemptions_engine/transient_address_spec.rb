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

    describe "hooks" do
      context "creating a non-site address" do
        it "does not attempt to update the x, y, grid reference or area fields" do
          expect(AssignSiteDetailsService).not_to receive(:run)

          create(:transient_address)
        end
      end

      context "creating a site address" do
        it "does attempt to update the x, y, grid reference or area fields" do
          expect(AssignSiteDetailsService).to receive(:run)

          create(:transient_address, :site_address)
        end
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
      let(:address_type) { 2 }
      subject(:address) { described_class.create_from_address_finder_data(address_finder_data, address_type) }

      it "creates an address from the address finder data" do
        expectations.keys.each do |property|
          expect(address.send(property)).to eq(expectations[property])
        end
      end
    end

    describe ".create_from_grid_reference_data", vcr: true do
      before(:context) { VCR.insert_cassette("site_address_from_grid_ref_auto_area", allow_playback_repeats: true) }
      after(:context) { VCR.eject_cassette }

      let(:grid_reference_data) do
        {
          grid_reference: "ST 58337 72855",
          description: "The waste is stored in an out-building next to the barn."
        }
      end
      let(:address_type) { 3 }
      subject(:address) { described_class.create_from_grid_reference_data(grid_reference_data, address_type) }

      it "creates an address from the grid reference" do
        grid_reference_data.keys.each do |property|
          expect(address.send(property)).to eq(grid_reference_data[property])
        end
      end
    end
  end
end
