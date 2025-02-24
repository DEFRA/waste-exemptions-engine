# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationPendingBankTransferEmailService do
    describe "run" do
      let(:registration) { create(:registration, :complete, account: build(:account)) }
      let(:order) { create(:order, :with_charge_detail, order_owner: registration.account) }
      let(:recipient) { registration.contact_email }
      let(:reference) { "WEX0123456" }

      subject(:run_service) { described_class.run(registration: registration, recipient: recipient) }

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:parameters) { { registration: registration, recipient: registration.contact_email } }
      end

      before do
        allow(registration).to receive(:reference).and_return(reference)
      end

      it "sends an email" do
        VCR.use_cassette("registration_pending_bank_transfer_email") do
          expect(run_service).to be_a(Notifications::Client::ResponseNotification)
        end
      end

      it "uses the expected Notify template" do
        VCR.use_cassette("registration_pending_bank_transfer_email") do
          expect(run_service.template["id"]).to eq("90aef20a-0d44-4b06-8a99-b0afbcdaa406")
        end
      end

      it "the email has the expected subject" do
        VCR.use_cassette("registration_pending_bank_transfer_email") do
          expect(run_service.content["subject"]).to eq("Payment needed for your waste exemption registration")
        end
      end
    end
  end
end
