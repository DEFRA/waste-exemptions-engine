# frozen_string_literal: true

require "rails_helper"
require "airbrake"

module WasteExemptionsEngine
  RSpec.describe DetermineXAndYService, type: :model do
    describe ".run" do
      let(:valid_grid_reference) { "ST 58337 72855" }
      let(:invalid_grid_reference) { "ZZ 00001 00001" }
      let(:valid_postcode) { "BS1 5AH" }
      let(:invalid_postcode) { "BS1 9XX" }

      context "when both grid reference and postcode are set" do
        let(:arguments) { { grid_reference: valid_grid_reference, postcode: valid_postcode } }

        it "returns a hash of x & y based on the grid reference" do
          expect(described_class.run(arguments)).to eq(x: 358_337.0, y: 172_855.0)
        end

        context "and grid reference is invalid" do
          before(:context) { VCR.insert_cassette("site_address_manual", allow_playback_repeats: true) }
          after(:context) { VCR.eject_cassette }

          let(:arguments) { { grid_reference: invalid_grid_reference, postcode: valid_postcode } }

          it "will notify Errbit of the error but still return a hash of x & y based on the postcode" do
            expect(Airbrake).to receive(:notify)
            expect(described_class.run(arguments)).to eq(x: 358_205.03, y: 172_708.07)
          end
        end

        context "and both are invalid" do
          let(:arguments) { { grid_reference: invalid_grid_reference, postcode: invalid_postcode } }

          it "will notify Errbit of the errors and returns a hash of x & y set to 0.0" do
            expect(Airbrake).to receive(:notify).twice
            expect(described_class.run(arguments)).to eq(x: 0.0, y: 0.0)
          end
        end

        context "and both are blank" do
          let(:arguments) { { grid_reference: nil, postcode: nil } }

          it "returns a hash of x & y set to nil" do
            expect(described_class.run(arguments)).to eq(x: nil, y: nil)
          end
        end
      end

      context "when only grid reference is set" do
        let(:arguments) { { grid_reference: valid_grid_reference, postcode: nil } }

        it "returns a hash of x & y based on the grid reference" do
          expect(described_class.run(arguments)).to eq(x: 358_337.0, y: 172_855.0)
        end

        context "and it is invalid" do
          let(:arguments) { { grid_reference: invalid_grid_reference, postcode: nil } }

          it "will notify Errbit of the error and returns a hash of x & y set to 0.0" do
            expect(Airbrake).to receive(:notify)
            expect(described_class.run(arguments)).to eq(x: 0.0, y: 0.0)
          end
        end
      end

      context "when only postcode is set" do
        before(:context) { VCR.insert_cassette("site_address_manual", allow_playback_repeats: true) }
        after(:context) { VCR.eject_cassette }

        let(:arguments) { { grid_reference: nil, postcode: valid_postcode } }

        it "returns a hash of x & y based on the postcode" do
          expect(described_class.run(arguments)).to eq(x: 358_205.03, y: 172_708.07)
        end

        context "and it is invalid" do
          let(:arguments) { { grid_reference: nil, postcode: invalid_postcode } }

          it "will notify Errbit of the error and returns a hash of x & y set to 0.0" do
            expect(Airbrake).to receive(:notify)
            expect(described_class.run(arguments)).to eq(x: 0.0, y: 0.0)
          end
        end
      end
    end
  end
end
