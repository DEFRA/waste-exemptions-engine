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
      let(:address_lookup_response) { instance_double(DefraRuby::Address::Response, successful?: successful, results: address_lookup_results, error: error) }
      let(:address_lookup_results) { [{ "x" => 358_205.03, "y" => 172_708.07 }] }
      let(:address_lookup_service) { instance_double(AddressLookupService) }

      before do
        allow(AddressLookupService).to receive(:new).and_return(address_lookup_service)
        allow(address_lookup_service).to receive(:run).and_return(address_lookup_response)
        allow(Airbrake).to receive(:notify)
      end

      context "when both grid reference and postcode are set" do
        let(:arguments) { { grid_reference: valid_grid_reference, postcode: valid_postcode } }

        context "when both are valid" do
          let(:successful) { true }
          let(:error) { nil }

          it "returns a hash of x & y based on the grid reference" do
            expect(described_class.run(arguments)).to eq(easting: 358_337.0, northing: 172_855.0)
          end
        end

        context "when grid reference is invalid" do
          let(:arguments) { { grid_reference: invalid_grid_reference, postcode: valid_postcode } }
          let(:successful) { true }
          let(:error) { nil }

          it "notifies Errbit of the error but still return a hash of x & y based on the postcode" do
            aggregate_failures do
              expect(described_class.run(arguments)).to eq(easting: 358_205.03, northing: 172_708.07)
              expect(Airbrake).to have_received(:notify)
            end
          end
        end

        context "when both are invalid" do
          let(:arguments) { { grid_reference: invalid_grid_reference, postcode: invalid_postcode } }
          let(:successful) { false }
          let(:error) { instance_double(StandardError, message: "Oops") }

          it "notifies Errbit of the errors and return a hash of x & y set to 0.0" do
            aggregate_failures do
              expect(described_class.run(arguments)).to eq(easting: 0.0, northing: 0.0)
              expect(Airbrake).to have_received(:notify).twice
            end
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

        context "when it is invalid" do
          let(:arguments) { { grid_reference: invalid_grid_reference, postcode: nil } }

          it "notifies Errbit of the error and return a hash of x & y set to 0.0" do
            aggregate_failures do
              expect(described_class.run(arguments)).to eq(easting: 0.0, northing: 0.0)
              expect(Airbrake).to have_received(:notify)
            end
          end
        end
      end

      context "when only postcode is set" do
        context "when it is valid" do
          let(:arguments) { { grid_reference: nil, postcode: valid_postcode } }
          let(:successful) { true }
          let(:error) { nil }

          it "returns a hash of x & y based on the postcode" do
            expect(described_class.run(arguments)).to eq(easting: 358_205.03, northing: 172_708.07)
          end
        end

        context "when it is not recognised" do
          let(:arguments) { { grid_reference: nil, postcode: invalid_postcode } }
          let(:address_lookup_results) { [] }
          let(:successful) { false }
          let(:error) { DefraRuby::Address::NoMatchError.new }

          it "notifies Errbit of the error and returns a hash of x & y set to 0.0" do
            aggregate_failures do
              expect(described_class.run(arguments)).to eq(easting: 0.0, northing: 0.0)
              expect(Airbrake).to have_received(:notify)
            end
          end
        end

        context "when the address lookup errors" do
          let(:arguments) { { grid_reference: nil, postcode: valid_postcode } }
          let(:successful) { false }
          let(:error) { instance_double(StandardError, message: "Oops") }

          it "notifies Errbit of the error and returns a hash of x & y set to 0.0" do
            aggregate_failures do
              expect(described_class.run(arguments)).to eq(easting: 0.0, northing: 0.0)
              expect(Airbrake).to have_received(:notify)
            end
          end
        end
      end
    end
  end
end
