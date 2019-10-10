# frozen_string_literal: true

require "rails_helper"
require "airbrake"

module WasteExemptionsEngine
  RSpec.describe DetermineGridReferenceService, type: :model do
    describe ".run" do
      let(:valid_easting) { 358_337.0 }
      let(:invalid_easting) { 1 }
      let(:valid_northing) { 172_855.0 }

      context "when both easting and northing are set" do
        let(:arguments) { { easting: valid_easting, northing: valid_northing } }

        it "returns the grid reference" do
          expect(described_class.run(arguments)).to eq("ST 58337 72855")
        end

        context "and one of them is invalid" do
          let(:arguments) { { easting: invalid_easting, northing: valid_northing } }

          it "will notify Errbit of the errors and return ''" do
            expect(Airbrake).to receive(:notify)
            expect(described_class.run(arguments)).to eq("")
          end
        end
      end

      context "when passed invalid arguments" do
        context "for example 'nil'" do
          let(:arguments) { { easting: nil, northing: 215_313 } }

          it "returns 'nil'" do
            expect(described_class.run(arguments)).to be_nil
          end
        end

        context "for example not a numeric value" do
          let(:arguments) { { easting: "not_a_number", northing: 215_313 } }

          it "returns 'nil'" do
            expect(described_class.run(arguments)).to be_nil
          end
        end
      end
    end
  end
end
