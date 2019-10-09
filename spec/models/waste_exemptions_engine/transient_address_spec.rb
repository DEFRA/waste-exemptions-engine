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

    describe "#valid_x_and_y?" do
      context "when x and y are set and not 0.0" do
        subject(:transient_address) { build(:transient_address, :site_using_address_lookup) }

        it "returns true" do
          expect(subject.valid_x_and_y?).to be(true)
        end
      end

      context "when x and y are blank" do
        subject(:transient_address) { build(:transient_address) }
        it "returns false" do
          expect(subject.valid_x_and_y?).to be(false)
        end
      end

      context "when x and y are 0.0" do
        subject(:transient_address) { build(:transient_address, x: 0.0, y: 0.0) }
        it "returns false" do
          expect(subject.valid_x_and_y?).to be(false)
        end
      end
    end

    describe "hooks" do
      context "creating a non-site address" do
        it "does not attempt to update the x, y, grid reference or area fields" do
          expect(AreaLookupService).not_to receive(:run)
          expect(DetermineGridReferenceService).not_to receive(:run)
          expect(DetermineXAndYService).not_to receive(:run)

          address = create(:transient_address)

          expect(address.x).to be_nil
          expect(address.y).to be_nil
          expect(address.grid_reference).to be_nil
          expect(address.area).to be_nil
        end
      end

      context "creating a site address" do
        let(:area_result) { "Wessex" }
        let(:grid_reference_result) { "ST 58337 72855" }
        let(:x_y_result) { { x: 358_337.0, y: 172_855.0 } }

        before(:each) do
          allow(AreaLookupService)
            .to receive(:run)
            .and_return(area_result)
          allow(DetermineGridReferenceService)
            .to receive(:run)
            .and_return(grid_reference_result)
          allow(DetermineXAndYService)
            .to receive(:run)
            .and_return(x_y_result)
        end

        context "populated from a grid reference" do
          subject(:transient_address) { create(:transient_address, :site_using_grid_reference) }

          it "updates the x & y and area fields" do
            expect(subject.x).to eq(x_y_result[:x])
            expect(subject.y).to eq(x_y_result[:y])
            expect(subject.area).to eq(area_result)
          end

          context "if the grid reference is somehow blank" do
            let(:x_y_result) { { x: nil, y: nil } }
            subject(:transient_address) { create(:transient_address, :site_address) }

            it "will do nothing" do
              expect(subject.x).to eq(x_y_result[:x])
              expect(subject.y).to eq(x_y_result[:y])
              expect(subject.area).to be_nil
            end
          end

          context "if the grid reference is invalid" do
            let(:x_y_result) { { x: 0.0, y: 0.0 } }
            subject(:transient_address) { create(:transient_address, :site_using_invalid_grid_reference) }

            it "set x & y to 0.0 and not update the area" do
              expect(subject.x).to eq(x_y_result[:x])
              expect(subject.y).to eq(x_y_result[:y])
              expect(subject.area).to be_nil
            end
          end
        end

        context "populated from a manual address" do
          subject(:transient_address) { create(:transient_address, :site_using_a_manual_address) }

          it "updates the x & y, grid reference and area fields" do
            expect(subject.x).to eq(x_y_result[:x])
            expect(subject.y).to eq(x_y_result[:y])
            expect(subject.grid_reference).to eq(grid_reference_result)
            expect(subject.area).to eq(area_result)
          end

          context "if the postcode is somehow blank" do
            let(:grid_reference_result) { nil }
            let(:x_y_result) { { x: nil, y: nil } }
            subject(:transient_address) { create(:transient_address, :site_address) }

            it "will do nothing" do
              expect(subject.x).to eq(x_y_result[:x])
              expect(subject.y).to eq(x_y_result[:y])
              expect(subject.grid_reference).to eq(grid_reference_result)
              expect(subject.area).to be_nil
            end
          end

          context "if the postcode is invalid" do
            let(:x_y_result) { { x: 0.0, y: 0.0 } }
            subject(:transient_address) { create(:transient_address, :site_using_invalid_manual_address) }

            it "will set x & y to 0.0" do
              expect(subject.x).to eq(x_y_result[:x])
              expect(subject.y).to eq(x_y_result[:y])
              expect(subject.grid_reference).to be_nil
              expect(subject.area).to be_nil
            end
          end
        end

        context "populated from address lookup" do
          subject(:transient_address) { create(:transient_address, :site_using_address_lookup) }

          it "updates the grid reference and area fields" do
            expect(subject.grid_reference).to eq(grid_reference_result)
            expect(subject.area).to eq(area_result)
          end

          context "if the x & y are somehow blank" do
            let(:x_y_result) { { x: nil, y: nil } }
            subject(:transient_address) { create(:transient_address, :site_address) }

            it "will do nothing" do
              expect(subject.grid_reference).to be_nil
              expect(subject.area).to be_nil
            end
          end

          context "if the x & y is invalid" do
            let(:grid_reference_result) { "" }
            let(:area_result) { "Outside England" }
            subject(:transient_address) { create(:transient_address, :site_using_invalid_address_lookup) }

            it "will do nothing" do
              expect(subject.grid_reference).to eq(grid_reference_result)
              expect(subject.area).to eq(area_result)
            end
          end
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

      it "does not automatically determine the grid reference" do
        expect(address.grid_reference).to be_nil
      end

      context "when the address is a site address" do
        before(:context) { VCR.insert_cassette("site_address_from_lookup_auto_area", allow_playback_repeats: true) }
        after(:context) { VCR.eject_cassette }

        let(:address_type) { 3 }

        it "does automatically determine the grid reference" do
          expect(address.grid_reference).to eq("ST 58205 72708")
        end

        it "does automatically determine the area" do
          expect(address.area).to eq("Wessex")
        end
      end
    end

    describe ".create_from_grid_reference_data" do
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

      it "automatically determines the x & y values" do
        x_and_y = { x: address.x, y: address.y }
        expect(x_and_y).to eq(x: 358_337.0, y: 172_855.0)
      end

      it "does automatically determine the area" do
        expect(address.area).to eq("Wessex")
      end
    end
  end
end
