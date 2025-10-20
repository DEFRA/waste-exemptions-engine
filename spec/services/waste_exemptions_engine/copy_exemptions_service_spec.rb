# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CopyExemptionsService do
    describe ".run" do
      let(:transient_registration) { create(:new_charged_registration) }
      let(:registration) { build(:registration) }
      let!(:site_address) { create(:address, :site_address, registration: registration) }

      context "when there are multiple exemptions" do
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

        it "creates registration_exemptions linked to the site address" do
          described_class.run(
            transient_registration_exemptions: transient_registration.transient_registration_exemptions,
            site_address: site_address
          )

          aggregate_failures do
            expect(registration.registration_exemptions.count).to eq(2)
            expect(registration.registration_exemptions.first.address).to eq(site_address)
            expect(registration.registration_exemptions.second.address).to eq(site_address)
          end
        end

        it "copies the exemption attributes correctly" do
          described_class.run(
            transient_registration_exemptions: transient_registration.transient_registration_exemptions,
            site_address: site_address
          )

          exemption_codes = registration.registration_exemptions.map { |re| re.exemption.code }
          expect(exemption_codes).to contain_exactly("T1", "T2")
        end
      end

      context "when there are no exemptions" do
        it "does not create any registration_exemptions" do
          described_class.run(
            transient_registration_exemptions: transient_registration.transient_registration_exemptions,
            site_address: site_address
          )

          expect(registration.registration_exemptions.count).to eq(0)
        end
      end
    end
  end
end
