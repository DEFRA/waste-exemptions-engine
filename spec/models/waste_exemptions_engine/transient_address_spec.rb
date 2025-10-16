# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientAddress do
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
      before { allow(AssignSiteDetailsService).to receive(:run) }

      context "when creating a non-site address" do
        it "does not attempt to update the x, y, grid reference or area fields" do
          create(:transient_address)

          expect(AssignSiteDetailsService).not_to have_received(:run)
        end
      end

      context "when creating a site address" do
        it "does attempt to update the x, y, grid reference or area fields" do
          create(:transient_address, :site_address)

          expect(AssignSiteDetailsService).to have_received(:run)
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
        expectations.each_key do |property|
          expect(address.send(property)).to eq(expectations[property])
        end
      end
    end

    describe ".create_from_grid_reference_data", :vcr do
      before { VCR.insert_cassette("site_address_from_grid_ref_auto_area", allow_playback_repeats: true) }
      after { VCR.eject_cassette }

      let(:grid_reference_data) do
        {
          grid_reference: "ST 58337 72855",
          description: "The waste is stored in an out-building next to the barn."
        }
      end
      let(:expectations) do
        {
          grid_reference: "ST 58337 72855",
          description: "The waste is stored in an out-building next to the barn."
        }
      end
      let(:address_type) { 3 }

      subject(:address) { described_class.create_from_grid_reference_data(grid_reference_data, address_type) }

      it "creates an address from the grid reference" do
        expectations.each_key do |property|
          expect(address.send(property)).to eq(expectations[property])
        end
      end
    end

    describe "#displayable_address_lines" do
      subject(:address) { build(:transient_address, attributes) }

      context "when all address fields are present" do
        let(:attributes) do
          {
            organisation: "Acme Ltd",
            premises: "Unit 5",
            street_address: "123 High Street",
            locality: "Clifton",
            city: "Bristol",
            postcode: "BS1 5AH"
          }
        end

        it "returns all address lines" do
          expect(address.displayable_address_lines).to eq(
            ["Acme Ltd", "Unit 5", "123 High Street", "Clifton", "Bristol", "BS1 5AH"]
          )
        end
      end

      context "when some address fields are blank" do
        let(:attributes) do
          {
            organisation: nil,
            premises: "Unit 5",
            street_address: "123 High Street",
            locality: "",
            city: "Bristol",
            postcode: "BS1 5AH"
          }
        end

        it "returns only non-blank address lines" do
          expect(address.displayable_address_lines).to eq(
            ["Unit 5", "123 High Street", "Bristol", "BS1 5AH"]
          )
        end
      end

      context "when all address fields are blank" do
        let(:attributes) do
          {
            organisation: nil,
            premises: "",
            street_address: nil,
            locality: "",
            city: nil,
            postcode: ""
          }
        end

        it "returns an empty array" do
          expect(address.displayable_address_lines).to eq([])
        end
      end
    end

    describe "#site_identifier" do
      subject(:address) { build(:transient_address, attributes) }

      context "when grid reference is present" do
        let(:attributes) do
          {
            grid_reference: "ST 58337 72855",
            premises: "Unit 5",
            street_address: "123 High Street",
            city: "Bristol",
            postcode: "BS1 5AH"
          }
        end

        it "returns the grid reference" do
          expect(address.site_identifier).to eq("ST 58337 72855")
        end
      end

      context "when grid reference is blank and address is present" do
        let(:attributes) do
          {
            grid_reference: "",
            premises: "Unit 5",
            street_address: "123 High Street",
            city: "Bristol",
            postcode: "BS1 5AH"
          }
        end

        it "returns the formatted address" do
          expect(address.site_identifier).to eq("Unit 5, 123 High Street, Bristol, BS1 5AH")
        end
      end

      context "when grid reference is nil and address is present" do
        let(:attributes) do
          {
            grid_reference: nil,
            organisation: "Acme Ltd",
            premises: "Unit 5",
            street_address: "123 High Street",
            locality: "Clifton",
            city: "Bristol",
            postcode: "BS1 5AH"
          }
        end

        it "returns the formatted address with all fields" do
          expect(address.site_identifier).to eq("Acme Ltd, Unit 5, 123 High Street, Clifton, Bristol, BS1 5AH")
        end
      end

      context "when grid reference is blank and some address fields are blank" do
        let(:attributes) do
          {
            grid_reference: nil,
            organisation: nil,
            premises: "Unit 5",
            street_address: "123 High Street",
            locality: "",
            city: "Bristol",
            postcode: "BS1 5AH"
          }
        end

        it "returns the formatted address excluding blank fields" do
          expect(address.site_identifier).to eq("Unit 5, 123 High Street, Bristol, BS1 5AH")
        end
      end
    end
  end
end
