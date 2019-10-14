# frozen_string_literal: true

require "rails_helper"
require "airbrake"

module WasteExemptionsEngine
  RSpec.describe DetermineGridReferenceService, type: :model do
    describe ".run" do
      let(:easting) { 358_337.0 }
      let(:northing) { 172_855.0 }
      let(:location) { double(:location) }

      it "fetch a grid reference from Os maps" do
        expect(described_class.run(easting: easting, northing: northing)).to eq("ST 58337 72855")
      end

      it "does not notify Airbrake and Rails" do
        expect(Airbrake).to_not receive(:notify)
        expect(Rails.logger).to_not receive(:error)
      end

      context "when an error happens" do
        before do
          expect(OsMapRef::Location).to receive(:for).and_raise(StandardError)
        end

        it "returns nil" do
          expect(described_class.run(easting: easting, northing: northing)).to be_empty
        end

        it "notify Airbrake and Rails" do
          expect(Airbrake).to receive(:notify)
          expect(Rails.logger).to receive(:error)

          described_class.run(easting: easting, northing: northing)
        end
      end
    end
  end
end
