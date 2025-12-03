# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CopyExemptionsService do
    RSpec.shared_examples "copies exemptions without site associations to all sites" do
      let(:registration) { create(:registration) }
      let(:address_mapping) { {} }

      context "with multiple sites" do
        let!(:first_site_address) { create(:address, :site_address, registration: registration) }
        let!(:second_site_address) { create(:address, :site_address, registration: registration) }

        before do
          exemption1 = create(:exemption, code: "T1")
          exemption2 = create(:exemption, code: "T2")

          # No transient_address_id - simulates new registration
          create(:transient_registration_exemption,
                 transient_registration: transient_registration,
                 exemption: exemption1,
                 transient_address: nil)
          create(:transient_registration_exemption,
                 transient_registration: transient_registration,
                 exemption: exemption2,
                 transient_address: nil)
        end

        it "duplicates each exemption to all site addresses" do
          described_class.run(
            transient_registration: transient_registration,
            registration: registration,
            address_mapping: address_mapping
          )

          # 2 exemptions × 2 sites = 4 registration_exemptions
          expect(registration.registration_exemptions.count).to eq(4)
        end

        it "creates exemptions for each site" do
          described_class.run(
            transient_registration: transient_registration,
            registration: registration,
            address_mapping: address_mapping
          )

          site1_exemptions = registration.registration_exemptions.select { |re| re.address == first_site_address }
          site2_exemptions = registration.registration_exemptions.select { |re| re.address == second_site_address }

          aggregate_failures do
            expect(site1_exemptions.count).to eq(2)
            expect(site2_exemptions.count).to eq(2)
            expect(site1_exemptions.map { |re| re.exemption.code }).to contain_exactly("T1", "T2")
            expect(site2_exemptions.map { |re| re.exemption.code }).to contain_exactly("T1", "T2")
          end
        end
      end

      context "with single site" do
        let!(:site_address) { create(:address, :site_address, registration: registration) }

        before do
          exemption1 = create(:exemption, code: "T1")
          exemption2 = create(:exemption, code: "T2")

          create(:transient_registration_exemption,
                 transient_registration: transient_registration,
                 exemption: exemption1,
                 transient_address: nil)
          create(:transient_registration_exemption,
                 transient_registration: transient_registration,
                 exemption: exemption2,
                 transient_address: nil)
        end

        it "creates one registration_exemption per exemption" do
          described_class.run(
            transient_registration: transient_registration,
            registration: registration,
            address_mapping: address_mapping
          )

          # 2 exemptions × 1 site = 2 registration_exemptions
          expect(registration.registration_exemptions.count).to eq(2)
        end

        it "links all exemptions to the single site" do
          described_class.run(
            transient_registration: transient_registration,
            registration: registration,
            address_mapping: address_mapping
          )

          expect(registration.registration_exemptions.map(&:address)).to all(eq(site_address))
        end
      end

      context "when there are no exemptions" do
        it "does not create any registration_exemptions" do
          described_class.run(
            transient_registration: transient_registration,
            registration: registration,
            address_mapping: address_mapping
          )

          expect(registration.registration_exemptions.count).to eq(0)
        end
      end
    end

    RSpec.shared_examples "preserves site-specific exemption associations" do
      let(:registration) { create(:registration) }
      let(:address_mapping) { {} }
      let(:transient_registration) { create(:renewing_registration) }
      let!(:first_transient_site) { create(:transient_address, :site_address, transient_registration: transient_registration) }
      let!(:second_transient_site) { create(:transient_address, :site_address, transient_registration: transient_registration) }
      let!(:first_new_site) { create(:address, :site_address, registration: registration) }
      let!(:second_new_site) { create(:address, :site_address, registration: registration) }

      let(:address_mapping) do
        {
          first_transient_site.id => first_new_site,
          second_transient_site.id => second_new_site
        }
      end

      before do
        # Clear any exemptions created by the factory
        transient_registration.transient_registration_exemptions.destroy_all

        exemption1 = create(:exemption, code: "T1")
        exemption2 = create(:exemption, code: "T2")

        # With transient_address_id - simulates renewal
        create(:transient_registration_exemption,
               transient_registration: transient_registration,
               exemption: exemption1,
               transient_address: first_transient_site)
        create(:transient_registration_exemption,
               transient_registration: transient_registration,
               exemption: exemption2,
               transient_address: second_transient_site)
      end

      it "maps each exemption to its corresponding site address" do
        described_class.run(
          transient_registration: transient_registration.reload,
          registration: registration,
          address_mapping: address_mapping
        )

        # 2 exemptions mapped 1:1 = 2 registration_exemptions
        expect(registration.registration_exemptions.count).to eq(2)
      end

      it "preserves the site association" do
        described_class.run(
          transient_registration: transient_registration.reload,
          registration: registration,
          address_mapping: address_mapping
        )

        site1_exemption = registration.registration_exemptions.find { |re| re.exemption.code == "T1" }
        site2_exemption = registration.registration_exemptions.find { |re| re.exemption.code == "T2" }

        aggregate_failures do
          expect(site1_exemption.address).to eq(first_new_site)
          expect(site2_exemption.address).to eq(second_new_site)
        end
      end
    end

    describe ".run" do
      context "with new charged registrations" do
        context "when single-site" do
          let(:transient_registration) { create(:new_charged_registration) }

          it_behaves_like "copies exemptions without site associations to all sites"
        end

        context "when multisite" do
          let(:transient_registration) { create(:new_charged_registration, :multisite) }

          it_behaves_like "copies exemptions without site associations to all sites"
        end
      end

      context "with renewing registrations" do
        context "when single-site" do
          let(:transient_registration) { create(:renewing_registration) }

          it_behaves_like "preserves site-specific exemption associations"
        end

        context "when multisite" do
          let(:transient_registration) { create(:renewing_registration, :from_multisite_registration) }

          it_behaves_like "preserves site-specific exemption associations"
        end
      end
    end
  end
end
