# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe AddressHelper, type: :helper do
    describe "#add_or_replace_address" do

      let(:result) { helper.add_or_replace_address(address, existing_addresses, existing_address) }

      context "when the address to replace is nil" do
        let(:existing_addresses) { double(:existing_addresses) }
        let(:existing_address) { :existing_address }
        let(:address) { nil }

        it "returns the existing address" do
          expect(result).to eq(existing_addresses)
        end
      end

      context "when the address to replace is not nil" do
        let(:existing_address) { double(:existing_address, id: 1) }
        let(:address) { double(:address) }

        context "when the address to replace's id is present already in the existing addresses" do
          let(:existing_addresses) { [existing_address] }

          it "delete the address from the array and fron the database and add the new instance" do
            expect(existing_addresses).to receive(:find).with(1).and_return(existing_address)
            expect(existing_address).to receive(:delete)
            expect(result).to eq([address])
          end
        end

        context "when the address to replace is not present in the existing addresses" do
          let(:existing_addresses) { [] }

          it "adds the address to the array of existing addresses" do
            expect(existing_addresses).to receive(:find).with(1).and_return(nil)
            expect(result).to eq([address])
          end
        end
      end
    end
  end
end
