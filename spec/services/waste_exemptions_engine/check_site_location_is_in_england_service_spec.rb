# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CheckSiteLocationIsInEnglandService do
    describe ".run" do
      let(:grid_reference) { "ST 58337 72855" }
      let(:coordinates) { { easting: 358_337.0, northing: 172_855.0 } }

      context "when a grid reference resolves to a location in England" do
        before do
          allow(DetermineEastingAndNorthingService).to receive(:run).with(grid_reference:, postcode: nil).and_return(coordinates)
          allow(DetermineAreaService).to receive(:run).with(coordinates).and_return("Wessex")
        end

        it "returns true" do
          expect(described_class.run(grid_reference:)).to be(true)
        end
      end

      context "when a grid reference resolves to a location outside England" do
        before do
          allow(DetermineEastingAndNorthingService).to receive(:run).with(grid_reference:, postcode: nil).and_return(coordinates)
          allow(DetermineAreaService).to receive(:run)
            .with(coordinates)
            .and_return(EaPublicFaceArea::OUTSIDE_ENGLAND_NAME)
        end

        it "returns false" do
          expect(described_class.run(grid_reference:)).to be(false)
        end
      end

      context "when a grid reference cannot be converted to valid coordinates" do
        let(:coordinates) { { easting: 0.0, northing: 0.0 } }

        before do
          allow(DetermineEastingAndNorthingService).to receive(:run).with(grid_reference:, postcode: nil).and_return(coordinates)
          allow(DetermineAreaService).to receive(:run)
        end

        it "returns nil" do
          expect(described_class.run(grid_reference:)).to be_nil
        end

        it "does not attempt an area lookup" do
          described_class.run(grid_reference:)

          expect(DetermineAreaService).not_to have_received(:run)
        end
      end

      context "when coordinates are provided directly" do
        before do
          allow(DetermineEastingAndNorthingService).to receive(:run)
          allow(DetermineAreaService).to receive(:run).with(coordinates).and_return("Wessex")
        end

        it "does not derive them again" do
          described_class.run(easting: coordinates[:easting], northing: coordinates[:northing])

          expect(DetermineEastingAndNorthingService).not_to have_received(:run)
        end
      end

      context "when the area lookup errors" do
        let(:error) { StandardError.new("lookup failed") }

        before do
          allow(DetermineEastingAndNorthingService).to receive(:run).with(grid_reference:, postcode: nil).and_return(coordinates)
          allow(DetermineAreaService).to receive(:run).with(coordinates).and_raise(error)
          allow(Rails.logger).to receive(:error)
        end

        it "returns nil" do
          expect(described_class.run(grid_reference:)).to be_nil
        end

        it "logs the error" do
          described_class.run(grid_reference:)

          expect(Rails.logger).to have_received(:error).with("Site location England check failed:\n #{error}")
        end
      end
    end
  end
end
