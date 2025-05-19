# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EaPublicFaceArea, type: :model do
    let!(:north_east_area) { create(:ea_public_face_area, id_and_code: "53") }
    let!(:yorkshire_area) { create(:ea_public_face_area, id_and_code: "34") }
    let!(:east_midlands_area) { create(:ea_public_face_area, id_and_code: "50") }

    describe "validations" do
      describe "#name" do
        it "is invalid when empty" do
          area = EaPublicFaceArea.new(code: "ABC")
          expect(area.valid?).to be false
          expect(area.errors[:name]).to include("can't be blank")
        end
      end

      describe "#code" do
        it "is invalid when empty" do
          area = EaPublicFaceArea.new(name: "Test Area")
          expect(area.valid?).to be false
          expect(area.errors[:code]).to include("can't be blank")
        end
      end
    end

    describe ".containing_point" do
      context "with East Midlands Area" do
        let(:easting) { 447051.92 }
        let(:northing) { 342377.23 }

        it "finds areas containing the specified point with correct attributes" do
          result = EaPublicFaceArea.containing_point(easting, northing)
          expect(result).to include(east_midlands_area)

          found_area = result.first
          expect(found_area.code).to eq("EMD")
          expect(found_area.area_id).to eq("50")
          expect(found_area.name).to eq("East Midlands")
        end
      end

      context "with Yorkshire Area" do
        let(:easting) { 459170.35 }
        let(:northing) { 463696.92 }

        it "finds areas containing the specified point with correct attributes" do
          result = EaPublicFaceArea.containing_point(easting, northing)
          expect(result).to include(yorkshire_area)

          found_area = result.first
          expect(found_area.code).to eq("YOR")
          expect(found_area.area_id).to eq("34")
          expect(found_area.name).to eq("Yorkshire")
        end
      end

      context "with North East Area" do
        let(:easting) { 419294.16 }
        let(:northing) { 579576.53 }

        it "finds areas containing the specified point with correct attributes" do
          result = EaPublicFaceArea.containing_point(easting, northing)
          expect(result).to include(north_east_area)

          found_area = result.first
          expect(found_area.code).to eq("NEA")
          expect(found_area.area_id).to eq("53")
          expect(found_area.name).to eq("North East")
        end
      end

      it "does not find areas when the point is outside" do
        outside_easting = 100000.0
        outside_northing = 100000.0

        result = EaPublicFaceArea.containing_point(outside_easting, outside_northing)
        expect(result).to be_empty
      end
    end

    describe ".find_by_coordinates" do
      context "with Yorkshire Area" do
        let(:easting) { 459170.35 }
        let(:northing) { 463696.92 }

        it "returns the area containing the specified coordinates" do
          result = EaPublicFaceArea.find_by_coordinates(easting, northing)
          expect(result).to eq(yorkshire_area)
          expect(result.code).to eq("YOR")
          expect(result.area_id).to eq("34")
          expect(result.name).to eq("Yorkshire")
        end
      end

      context "with East Midlands Area" do
        let(:easting) { 447051.92 }
        let(:northing) { 342377.23 }

        it "returns the area containing the specified coordinates" do
          result = EaPublicFaceArea.find_by_coordinates(easting, northing)
          expect(result).to eq(east_midlands_area)
          expect(result.code).to eq("EMD")
          expect(result.area_id).to eq("50")
          expect(result.name).to eq("East Midlands")
        end
      end

      it "returns nil when no area contains the coordinates" do
        outside_easting = 100000.0
        outside_northing = 100000.0

        result = EaPublicFaceArea.find_by_coordinates(outside_easting, outside_northing)
        expect(result).to be_nil
      end
    end

    describe ".outside_england_area" do
      context "when the record already exists" do
        let!(:outside_england) do
          EaPublicFaceArea.create(
            code: EaPublicFaceArea::OUTSIDE_ENGLAND_CODE,
            name: "Outside England",
            area_id: "OUTSIDE_ENGLAND"
          )
        end

        it "returns the existing record" do
          result = EaPublicFaceArea.outside_england_area
          expect(result).to eq(outside_england)
        end
      end

      context "when the record does not exist" do
        it "creates and returns a new record" do
          expect {
            EaPublicFaceArea.outside_england_area
          }.to change(EaPublicFaceArea, :count).by(1)

          record = EaPublicFaceArea.find_by(code: EaPublicFaceArea::OUTSIDE_ENGLAND_CODE)
          expect(record.name).to eq("Outside England")
          expect(record.area_id).to eq("OUTSIDE_ENGLAND")
        end
      end
    end
  end
end
