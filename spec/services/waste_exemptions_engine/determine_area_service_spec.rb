# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe DetermineAreaService do
    describe ".run" do
      let(:coordinates) { { easting: 358_205.03, northing: 172_708.07 } }

      before do
        allow(DefraRuby::Area::PublicFaceAreaService)
          .to receive(:run)
          .with(coordinates[:easting], coordinates[:northing])
          .and_return(response)
      end

      context "when the lookup is successful" do
        let(:response) do
          double(:response, successful?: true, areas: [double(:area, long_name: "Wessex")])
        end

        it "returns the matching area" do
          expect(described_class.run(coordinates)).to eq("Wessex")
        end

        it "does not notify Airbrake of the error" do
          expect(Airbrake).to_not receive(:notify)

          described_class.run(coordinates)
        end
      end

      context "when the lookup is unsuccessful" do
        context "because no match was found" do
          let(:response) { double(:response, successful?: false, error: DefraRuby::Area::NoMatchError.new) }

          it "returns 'Outside England'" do
            expect(described_class.run(coordinates)).to eq("Outside England")
          end
        end

        context "because it failed" do
          let(:response) { double(:response, successful?: false, error: StandardError.new) }

          it "returns 'nil'" do
            expect(described_class.run(coordinates)).to be_nil
          end

          it "uses Airbrake to notify Errbit of the error" do
            expect(Airbrake).to receive(:notify)

            described_class.run(coordinates)
          end
        end
      end
    end
  end
end
