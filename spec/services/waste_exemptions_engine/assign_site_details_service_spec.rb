# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe AssignSiteDetailsService do
    let(:address) { create(:transient_address) }

    describe ".run" do
      let(:grid_reference) { "ST 12345 12345" }
      let(:area) { "Area" }
      let(:x) { 1234.5 }
      let(:y) { 1234.5 }
      let(:address) { build(:transient_address, x: x, y: y, grid_reference: grid_reference, area: area) }

      context "when it updates x and y" do
        context "when the address x and y are positive" do
          it "does not lookup for x and y coordinates" do
            allow(DetermineEastingAndNorthingService).to receive(:run)

            described_class.run(address: address)

            expect(DetermineEastingAndNorthingService).not_to have_received(:run)
          end
        end

        context "when the address x and y are missing" do
          let(:x) { nil }
          let(:y) { nil }
          let(:result) { { easting: 123.4, northing: 123.5 } }

          it "does lookup for x and y coordinates" do
            allow(DetermineEastingAndNorthingService).to receive(:run).and_return(result)

            described_class.run(address: address)

            expect(address.x).to eq(123.4)
            expect(address.y).to eq(123.5)
          end
        end
      end

      context "when it updates grid reference" do
        context "when the grid reference is missing" do
          let(:grid_reference) { nil }

          it "does lookup for a grid reference" do
            allow(DetermineGridReferenceService).to receive(:run).and_return("ST 54321 54321")

            described_class.run(address: address)

            expect(address.grid_reference).to eq("ST 54321 54321")
          end
        end

        context "when the grid reference is present already" do
          it "does not lookup for a grid reference" do
            allow(DetermineGridReferenceService).to receive(:run)

            described_class.run(address: address)

            expect(DetermineGridReferenceService).not_to have_received(:run)
          end
        end
      end

      context "when it updates area" do
        context "when the area is missing" do
          let(:area) { nil }

          it "does lookup for an area" do
            allow(DetermineAreaService).to receive(:run).and_return("An Area!")

            described_class.run(address: address)

            expect(address.area).to eq("An Area!")
          end
        end

        context "when the area is present already" do
          it "does not lookup for an area" do
            allow(DetermineAreaService).to receive(:run)

            described_class.run(address: address)

            expect(DetermineAreaService).not_to have_received(:run)
          end
        end
      end
    end
  end
end
