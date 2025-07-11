# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EaPublicFaceArea do
    let!(:north_east_area) { create(:ea_public_face_area, id_and_code: "53") }
    let!(:yorkshire_area) { create(:ea_public_face_area, id_and_code: "34") }
    let!(:east_midlands_area) { create(:ea_public_face_area, id_and_code: "50") }

    describe "validations" do
      describe "#name" do
        subject(:area) { described_class.new(code: "ABC") }

        it "is invalid when empty" do
          expect(area.valid?).to be false
        end

        it "has the correct error message" do
          area.valid?
          expect(area.errors[:name]).to include("can't be blank")
        end
      end

      describe "#code" do
        subject(:area) { described_class.new(name: "Test Area") }

        it "is invalid when empty" do
          expect(area.valid?).to be false
        end

        it "has the correct error message" do
          area.valid?
          expect(area.errors[:code]).to include("can't be blank")
        end
      end
    end

    describe ".containing_point" do
      context "with East Midlands Area" do
        let(:easting) { 447_051.92 }
        let(:northing) { 342_377.23 }
        let(:result) { described_class.containing_point(easting, northing) }
        let(:found_area) { result.first }

        it "includes the correct area in the result" do
          expect(result).to include(east_midlands_area)
        end

        it "returns an area with the correct code" do
          expect(found_area.code).to eq("EMD")
        end

        it "returns an area with the correct area_id" do
          expect(found_area.area_id).to eq("50")
        end

        it "returns an area with the correct name" do
          expect(found_area.name).to eq("East Midlands")
        end
      end

      context "with Yorkshire Area" do
        let(:easting) { 459_170.35 }
        let(:northing) { 463_696.92 }
        let(:result) { described_class.containing_point(easting, northing) }
        let(:found_area) { result.first }

        it "includes the correct area in the result" do
          expect(result).to include(yorkshire_area)
        end

        it "returns an area with the correct code" do
          expect(found_area.code).to eq("YOR")
        end

        it "returns an area with the correct area_id" do
          expect(found_area.area_id).to eq("34")
        end

        it "returns an area with the correct name" do
          expect(found_area.name).to eq("Yorkshire")
        end
      end

      context "with North East Area" do
        let(:easting) { 419_294.16 }
        let(:northing) { 579_576.53 }
        let(:result) { described_class.containing_point(easting, northing) }
        let(:found_area) { result.first }

        it "includes the correct area in the result" do
          expect(result).to include(north_east_area)
        end

        it "returns an area with the correct code" do
          expect(found_area.code).to eq("NEA")
        end

        it "returns an area with the correct area_id" do
          expect(found_area.area_id).to eq("53")
        end

        it "returns an area with the correct name" do
          expect(found_area.name).to eq("North East")
        end
      end

      context "with coordinates outside any area" do
        let(:outside_easting) { 100_000.0 }
        let(:outside_northing) { 100_000.0 }
        let(:result) { described_class.containing_point(outside_easting, outside_northing) }

        it "returns an empty result" do
          expect(result).to be_empty
        end
      end
    end

    describe ".find_by_coordinates" do
      context "with Yorkshire Area" do
        let(:easting) { 459_170.35 }
        let(:northing) { 463_696.92 }
        let(:result) { described_class.find_by_coordinates(easting, northing) }

        it "returns the correct area" do
          expect(result).to eq(yorkshire_area)
        end

        it "returns an area with the correct code" do
          expect(result.code).to eq("YOR")
        end

        it "returns an area with the correct area_id" do
          expect(result.area_id).to eq("34")
        end

        it "returns an area with the correct name" do
          expect(result.name).to eq("Yorkshire")
        end
      end

      context "with East Midlands Area" do
        let(:easting) { 447_051.92 }
        let(:northing) { 342_377.23 }
        let(:result) { described_class.find_by_coordinates(easting, northing) }

        it "returns the correct area" do
          expect(result).to eq(east_midlands_area)
        end

        it "returns an area with the correct code" do
          expect(result.code).to eq("EMD")
        end

        it "returns an area with the correct area_id" do
          expect(result.area_id).to eq("50")
        end

        it "returns an area with the correct name" do
          expect(result.name).to eq("East Midlands")
        end
      end

      context "with coordinates outside any area" do
        let(:outside_easting) { 100_000.0 }
        let(:outside_northing) { 100_000.0 }
        let(:result) { described_class.find_by_coordinates(outside_easting, outside_northing) }

        it "returns nil" do
          expect(result).to be_nil
        end
      end
    end

    describe ".outside_england_area" do
      context "when the record already exists" do
        let!(:outside_england) do
          described_class.create(
            code: EaPublicFaceArea::OUTSIDE_ENGLAND_CODE,
            name: "Outside England",
            area_id: "OUTSIDE_ENGLAND"
          )
        end
        let(:result) { described_class.outside_england_area }

        it "returns the existing record" do
          expect(result).to eq(outside_england)
        end
      end

      context "when the record does not exist" do
        it "creates a new record" do
          expect do
            described_class.outside_england_area
          end.to change(described_class, :count).by(1)
        end

        it "sets the correct name on the new record" do
          described_class.outside_england_area
          record = described_class.find_by(code: EaPublicFaceArea::OUTSIDE_ENGLAND_CODE)
          expect(record.name).to eq("Outside England")
        end

        it "sets the correct area_id on the new record" do
          described_class.outside_england_area
          record = described_class.find_by(code: EaPublicFaceArea::OUTSIDE_ENGLAND_CODE)
          expect(record.area_id).to eq("OUTSIDE_ENGLAND")
        end
      end
    end
  end
end
