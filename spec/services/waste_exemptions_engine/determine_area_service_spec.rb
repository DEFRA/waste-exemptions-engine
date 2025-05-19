# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe DetermineAreaService do
    describe ".run" do
      let(:coordinates) { { easting: 358_205.03, northing: 172_708.07 } }
      let(:area_name) { "Wessex" }
      let(:area) { instance_double(EaPublicFaceArea, name: area_name) }
      let(:outside_england) { instance_double(EaPublicFaceArea, name: "Outside England") }

      context "when the coordinates are within a known area" do
        before do
          allow(EaPublicFaceArea).to receive(:find_by_coordinates)
            .with(coordinates[:easting], coordinates[:northing])
            .and_return(area)
          
          allow(EaPublicFaceArea).to receive(:outside_england_area)
            .and_return(outside_england)
        end

        it "returns the matching area" do
          expect(described_class.run(coordinates)).to eq(area)
        end
      end

      context "when the coordinates are not within any known area" do
        before do
          allow(EaPublicFaceArea).to receive(:find_by_coordinates)
            .with(coordinates[:easting], coordinates[:northing])
            .and_return(nil)
          
          allow(EaPublicFaceArea).to receive(:outside_england_area)
            .and_return(outside_england)
        end

        it "returns the 'Outside England' area" do
          expect(described_class.run(coordinates)).to eq(outside_england)
        end
      end
    end
  end
end
