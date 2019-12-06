# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe AddressFinderService do
    describe ".run" do
      before do
        allow(DefraRuby::Address::EaAddressFacadeV1Service)
          .to receive(:run)
          .with(postcode)
          .and_return(response)
      end

      let(:postcode) { "BS1 5AH" }

      context "when the lookup is succesful" do
        let(:response) do
          double(:response, successful?: true, results: %w[address1 address2])
        end

        it "returns the matching area" do
          expect(described_class.run(postcode)).to eq(response.results)
        end

        it "does not notify Airbrake of the error" do
          expect(Airbrake).to_not receive(:notify)

          described_class.run(postcode)
        end
      end
    end
  end
end
