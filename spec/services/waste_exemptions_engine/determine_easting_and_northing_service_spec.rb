# frozen_string_literal: true

require "rails_helper"
require "airbrake"

module WasteExemptionsEngine
  RSpec.describe DetermineEastingAndNorthingService, type: :model do
    describe ".run" do
      let(:valid_grid_reference) { "ST 58337 72855" }
      let(:invalid_grid_reference) { "ZZ 00001 00001" }
      let(:valid_postcode) { "BS1 5AH" }
      let(:invalid_postcode) { "BS1 9XX" }
      let(:address_lookup_response) { double(:response, successful?: successful, results: address_lookup_results, error: error) }
      let(:address_lookup_results) { [{ "x" => 358_205.03, "y" => 172_708.07 }] }
      let(:address_finder_results) { [{ "x" => 358_205.03, "y" => 172_708.07 }] }

      before do
        allow_any_instance_of(AddressLookupService).to receive(:run)
          .and_return(address_lookup_response)
      end

      context "when both grid reference and postcode are set" do
        let(:arguments) { { grid_reference: valid_grid_reference, postcode: valid_postcode } }

        context "and both are valid" do
          let(:successful) { true }
          let(:error) { nil }

          it "returns a hash of x & y based on the grid reference" do
            expect(described_class.run(arguments)).to eq(easting: 358_337.0, northing: 172_855.0)
          end
        end

        context "and grid reference is invalid" do
          let(:arguments) { { grid_reference: invalid_grid_reference, postcode: valid_postcode } }
          let(:successful) { true }
          let(:error) { nil }

          it "will notify Errbit of the error but still return a hash of x & y based on the postcode" do
            expect(Airbrake).to receive(:notify)
            expect(described_class.run(arguments)).to eq(easting: 358_205.03, northing: 172_708.07)
          end
        end

        context "and both are invalid" do
          let(:arguments) { { grid_reference: invalid_grid_reference, postcode: invalid_postcode } }
          let(:successful) { false }
          let(:error) { double(:error, message: "Oops") }

          it "will notify Errbit of the errors and returns a hash of x & y set to 0.0" do
            expect(Airbrake).to receive(:notify).twice
            expect(described_class.run(arguments)).to eq(easting: 0.0, northing: 0.0)
          end
        end
      end

      context "when both grid reference and postcode are blank" do
        let(:arguments) { { grid_reference: nil, postcode: nil } }
        let(:successful) { true }
        let(:error) { nil }

        it "returns a hash of x & y set to nil" do
          expect(described_class.run(arguments)).to eq(easting: nil, northing: nil)
        end
      end

      context "when only grid reference is set" do
        let(:arguments) { { grid_reference: valid_grid_reference, postcode: nil } }
        let(:successful) { true }
        let(:error) { nil }

        it "returns a hash of x & y based on the grid reference" do
          expect(described_class.run(arguments)).to eq(easting: 358_337.0, northing: 172_855.0)
        end

        context "and it is invalid" do
          let(:arguments) { { grid_reference: invalid_grid_reference, postcode: nil } }

          it "will notify Errbit of the error and returns a hash of x & y set to 0.0" do
            expect(Airbrake).to receive(:notify)
            expect(described_class.run(arguments)).to eq(easting: 0.0, northing: 0.0)
          end
        end
      end

      context "when only postcode is set" do
        context "and it is valid" do
          let(:arguments) { { grid_reference: nil, postcode: valid_postcode } }
          let(:successful) { true }
          let(:error) { nil }

          it "returns a hash of x & y based on the postcode" do
            expect(described_class.run(arguments)).to eq(easting: 358_205.03, northing: 172_708.07)
          end
        end

        context "and it is not recognised" do
          let(:arguments) { { grid_reference: nil, postcode: invalid_postcode } }
          let(:address_lookup_results) { [] }
          let(:successful) { false }
          let(:error) { DefraRuby::Address::NoMatchError.new }

          it "will notify Errbit of the error and returns a hash of x & y set to 0.0" do
            expect(Airbrake).to receive(:notify)
            expect(described_class.run(arguments)).to eq(easting: 0.0, northing: 0.0)
          end
        end

        context "and the address lookup errors" do
          let(:arguments) { { grid_reference: nil, postcode: valid_postcode } }
          let(:successful) { false }
          let(:error) { double(:error, message: "Oops") }

          it "will notify Errbit of the error and returns a hash of x & y set to 0.0" do
            expect(Airbrake).to receive(:notify)
            expect(described_class.run(arguments)).to eq(easting: 0.0, northing: 0.0)
          end
        end
      end
    end
  end
end
