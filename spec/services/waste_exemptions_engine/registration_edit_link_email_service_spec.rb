# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationEditLinkEmailService do
    describe "run" do
      let(:registration) { create(:registration, :complete) }
      let(:recipient) { registration.contact_email }
      let(:reference) { "WEX0123456" }
      let(:magic_link_token) { registration.edit_token }

      subject(:run_service) { described_class.run(registration:, recipient:, magic_link_token:) }

      before do
        allow(registration).to receive_messages(reference: reference, edit_token: "rWiFivTGioee7AdWzTKEJp1J")
      end

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:a_registration) { create(:registration, :complete) }
        let(:parameters) { { registration: a_registration, magic_link_token:, recipient: a_registration.contact_email } }
      end

      it "sends an email" do
        VCR.use_cassette("registration_edit_link_email") do
          expect(run_service).to be_a(Notifications::Client::ResponseNotification)
        end
      end

      it "uses the expected Notify template" do
        VCR.use_cassette("registration_edit_link_email") do
          expect(run_service.template["id"]).to eq("09320726-38c6-4989-a831-17c7d4ff37db")
        end
      end

      it "the email has the expected subject" do
        VCR.use_cassette("registration_edit_link_email") do
          expect(run_service.content["subject"]).to eq("Waste exemptions – Update your contact details and deregister your waste exemptions")
        end
      end

      it "includes the magic link URL" do
        VCR.use_cassette("registration_edit_link_email") do
          expect(run_service.content["body"]).to match %r{http.*/edit/#{registration.edit_token}}
        end
      end
    end
  end
end
