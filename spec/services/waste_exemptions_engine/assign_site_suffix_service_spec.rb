# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe AssignSiteSuffixService do
    describe ".run" do
      let(:transient_registration) { create(:new_registration) }
      let(:address) { build(:transient_address, :site_address, transient_registration: transient_registration, site_suffix: nil) }

      context "when it is the first site address" do
        it "assigns site_suffix as 00001" do
          described_class.run(address: address)

          expect(address.site_suffix).to eq("00001")
        end
      end

      context "when there are existing site addresses" do
        before do
          create(:transient_address, :site_address, transient_registration: transient_registration, site_suffix: "00001")
          create(:transient_address, :site_address, transient_registration: transient_registration, site_suffix: "00002")
        end

        it "assigns the next site_suffix in the sequence" do
          described_class.run(address: address)

          expect(address.site_suffix).to eq("00003")
        end
      end

      context "when there are 99 existing site addresses" do
        before do
          99.times do |i|
            create(:transient_address, :site_address, transient_registration: transient_registration, site_suffix: format("%05d", i + 1))
          end
        end

        it "assigns site_suffix as 00100" do
          described_class.run(address: address)

          expect(address.site_suffix).to eq("00100")
        end
      end

      context "when the address has no associated registration" do
        let(:address) { build(:transient_address, :site_address, transient_registration: nil, site_suffix: nil) }

        it "does not assign a site_suffix" do
          described_class.run(address: address)

          expect(address.site_suffix).to be_nil
        end
      end

      context "when working with a Registration (not TransientRegistration)" do
        let(:registration) { create(:registration) }
        let(:address) { build(:address, :site_address, registration: registration, site_suffix: nil) }

        context "when it is the first site address" do
          it "assigns site_suffix as 00001" do
            described_class.run(address: address)

            expect(address.site_suffix).to eq("00001")
          end
        end

        context "when there are existing site addresses" do
          before do
            create(:address, :site_address, registration: registration, site_suffix: "00001")
            create(:address, :site_address, registration: registration, site_suffix: "00002")
          end

          it "assigns the next sequential site_suffix" do
            described_class.run(address: address)

            expect(address.site_suffix).to eq("00003")
          end
        end
      end
    end
  end
end
