# frozen_string_literal: true

require "rails_helper"
require "airbrake"

module WasteExemptionsEngine
  RSpec.describe DetermineGridReferenceService, type: :model do
    describe ".run" do
      let(:easting) { 358_337.0 }
      let(:northing) { 172_855.0 }

      before do
        allow(Airbrake).to receive(:notify)
        allow(Rails.logger).to receive(:error)
      end

      context "with 6-digit easting and northing values" do
        it "fetches a grid reference from OS Maps" do
          expect(described_class.run(easting: easting, northing: northing)).to eq("ST 58337 72855")
        end

        it "does not notify Airbrake and Rails" do
          described_class.run(easting: easting, northing: northing)

          expect(Airbrake).not_to have_received(:notify)
          expect(Rails.logger).not_to have_received(:error)
        end
      end

      context "with a 5-digit easting value" do
        let(:easting) { 58_337.0 }

        it "fetches the correct grid reference" do
          expect(described_class.run(easting: easting, northing: northing)).to eq("SQ 58337 72855")
        end
      end

      context "with a 5-digit northing value" do
        let(:northing) { 70_817.0 }

        it "fetches the correct grid reference" do
          expect(described_class.run(easting: easting, northing: northing)).to eq("SY 58337 70817")
        end
      end

      context "when an error happens" do
        before do
          allow(OsMapRef::Location).to receive(:for).and_raise(StandardError)
        end

        it "returns nil" do
          expect(described_class.run(easting: easting, northing: northing)).to be_empty
        end

        it "notify Airbrake and Rails" do
          described_class.run(easting: easting, northing: northing)

          expect(Airbrake).to have_received(:notify)
          expect(Rails.logger).to have_received(:error)
        end
      end
    end
  end
end
