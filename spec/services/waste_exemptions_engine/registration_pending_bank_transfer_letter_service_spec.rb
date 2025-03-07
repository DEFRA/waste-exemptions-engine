# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationPendingBankTransferLetterService do

    describe "run" do
      subject(:service) { described_class.run(registration: registration) }

      # Make sure it's a real postcode for Notify validation purposes
      let(:address) { create(:address, :postal, postcode: "BS1 1AA") }
      let(:registration) { create(:registration, :complete, :with_active_exemptions, account: build(:account)) }
      let(:order) { create(:order, :with_charge_detail, order_owner: registration.account) }

      before do
        registration.contact_address = address
      end

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:a_registration) { create(:registration, :complete, :with_active_exemptions, account: build(:account)) }
        let(:parameters) { { registration: a_registration } }
      end

      it "sends a letter" do
        VCR.use_cassette("registration_pending_bank_transfer_letter") do
          response = service
          aggregate_failures do
            expect(response).to be_a(Notifications::Client::ResponseNotification)
            expect(response.template["id"]).to eq("b614d958-8e85-4168-8e20-6f924dc47dff")
            expect(response.content["subject"]).to include("Payment needed for waste exemption registration #{registration.reference}")
          end
        end
      end
    end
  end
end
