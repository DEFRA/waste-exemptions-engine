# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe DetermineAreaService do
    subject(:service) { described_class.new }

    describe "#run" do
      let(:easting) { 358_205.03 }
      let(:northing) { 172_708.07 }
      let(:area_name) { "Wessex" }
      let(:area) { instance_double(EaPublicFaceArea, name: area_name) }

      context "when the coordinates are within a known area" do
        before do
          allow(EaPublicFaceArea).to receive(:find_by_coordinates)
            .with(easting, northing)
            .and_return(area)
        end

        it "returns the matching area name" do
          expect(service.run(easting: easting, northing: northing)).to eq(area_name)
        end
      end

      context "when the coordinates are not within any known area" do
        before do
          allow(EaPublicFaceArea).to receive(:find_by_coordinates)
            .with(easting, northing)
            .and_return(nil)
        end

        it "returns 'Outside England'" do
          expect(service.run(easting: easting, northing: northing)).to eq("Outside England")
        end
      end

      context "when coordinates are nil" do
        it "returns nil" do
          expect(service.run(easting: nil, northing: nil)).to be_nil
        end
      end

      context "when error occurs during area lookup" do
        let(:error) { StandardError.new("test error") }

        before do
          allow(EaPublicFaceArea).to receive(:find_by_coordinates)
            .with(easting, northing)
            .and_raise(error)

          allow(Rails.logger).to receive(:error)
          allow(Airbrake).to receive(:notify) if defined?(Airbrake)
        end

        it "logs the error" do
          begin
            service.run(easting: easting, northing: northing)
          rescue StandardError
            # Expected to raise error
          end

          expect(Rails.logger).to have_received(:error).with("Area lookup failed:\n #{error}")
        end

        it "notifies Airbrake if defined" do
          if defined?(Airbrake)
            begin
              service.run(easting: easting, northing: northing)
            rescue StandardError
              # Expected to raise error
            end

            expect(Airbrake).to have_received(:notify).with(error, easting: easting, northing: northing)
          end
        end

        it "re-raises the original error" do
          expect { service.run(easting: easting, northing: northing) }
            .to raise_error(StandardError, "test error")
        end
      end
    end
  end
end
