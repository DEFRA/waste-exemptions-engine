# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CopyExemptionsService do
    describe ".run" do
      let(:transient_registration) { create(:new_charged_registration) }
      let(:registration) { build(:registration) }

      before do
        exemption1 = create(:exemption, code: "T1")
        exemption2 = create(:exemption, code: "T2")

        create(:transient_registration_exemption,
               transient_registration: transient_registration,
               exemption: exemption1)
        create(:transient_registration_exemption,
               transient_registration: transient_registration,
               exemption: exemption2)
      end

      context "when it is a single-site registration" do
        before do
          allow(transient_registration).to receive(:multisite?).and_return(false)
        end

        context "when there is a site address" do
          let!(:site_address) { create(:address, :site_address, registration: registration) }

          it "creates registration_exemptions linked to the site address" do
            described_class.run(transient_registration: transient_registration, registration: registration)

            expect(registration.registration_exemptions.count).to eq(2)
            expect(registration.registration_exemptions.first.address).to eq(site_address)
            expect(registration.registration_exemptions.second.address).to eq(site_address)
          end

          it "copies the exemption attributes correctly" do
            described_class.run(transient_registration: transient_registration, registration: registration)

            exemption_codes = registration.registration_exemptions.map { |re| re.exemption.code }
            expect(exemption_codes).to contain_exactly("T1", "T2")
          end
        end

        context "when there is no site address" do
          before do
            create(:address, :operator_address, registration: registration)
          end

          it "creates registration_exemptions without address link" do
            described_class.run(transient_registration: transient_registration, registration: registration)

            expect(registration.registration_exemptions.count).to eq(2)
            expect(registration.registration_exemptions.first.address).to be_nil
            expect(registration.registration_exemptions.second.address).to be_nil
          end
        end
      end

      context "when it is a multisite registration" do
        let!(:site_address1) { create(:address, :site_address, registration: registration, site_suffix: "00001") }
        let!(:site_address2) { create(:address, :site_address, registration: registration, site_suffix: "00002") }
        let!(:site_address3) { create(:address, :site_address, registration: registration, site_suffix: "00003") }

        before do
          allow(transient_registration).to receive(:multisite?).and_return(true)
        end

        it "duplicates each exemption for every site address" do
          described_class.run(transient_registration: transient_registration, registration: registration)

          # 2 exemptions × 3 sites = 6 registration_exemptions
          expect(registration.registration_exemptions.count).to eq(6)
        end

        it "links each exemption to the correct site address" do
          described_class.run(transient_registration: transient_registration, registration: registration)

          site1_exemptions = registration.registration_exemptions.select { |re| re.address == site_address1 }
          site2_exemptions = registration.registration_exemptions.select { |re| re.address == site_address2 }
          site3_exemptions = registration.registration_exemptions.select { |re| re.address == site_address3 }

          expect(site1_exemptions.count).to eq(2)
          expect(site2_exemptions.count).to eq(2)
          expect(site3_exemptions.count).to eq(2)
        end

        it "copies the exemption attributes correctly for each site" do
          described_class.run(transient_registration: transient_registration, registration: registration)

          # Each site should have both T1 and T2 exemptions
          [site_address1, site_address2, site_address3].each do |site|
            site_exemptions = registration.registration_exemptions.select { |re| re.address == site }
            exemption_codes = site_exemptions.map { |re| re.exemption.code }
            expect(exemption_codes).to contain_exactly("T1", "T2")
          end
        end

        context "with 30 sites and 3 exemptions" do
          let(:exemption3) { create(:exemption, code: "T3") }

          before do
            create(:transient_registration_exemption,
                   transient_registration: transient_registration,
                   exemption: exemption3)

            # Clear existing addresses and add 30 sites
            registration.addresses.destroy_all
            30.times do |i|
              create(:address, :site_address, registration: registration, site_suffix: format("%05d", i + 1))
            end
            registration.reload
          end

          it "creates 90 registration_exemptions (3 × 30)" do
            described_class.run(transient_registration: transient_registration, registration: registration)

            expect(registration.registration_exemptions.count).to eq(90)
          end

          it "ensures each site has all 3 exemptions" do
            described_class.run(transient_registration: transient_registration, registration: registration)

            registration.site_addresses.each do |site|
              site_exemptions = registration.registration_exemptions.select { |re| re.address == site }
              expect(site_exemptions.count).to eq(3)
              exemption_codes = site_exemptions.map { |re| re.exemption.code }
              expect(exemption_codes).to contain_exactly("T1", "T2", "T3")
            end
          end
        end
      end

      context "when there are no exemptions" do
        let(:transient_registration_no_exemptions) { create(:new_charged_registration) }

        before do
          allow(transient_registration_no_exemptions).to receive(:multisite?).and_return(false)
        end

        it "does not create any registration_exemptions" do
          described_class.run(transient_registration: transient_registration_no_exemptions, registration: registration)

          expect(registration.registration_exemptions.count).to eq(0)
        end
      end
    end
  end
end
