# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationEditConfirmationEmailService do
    describe "run" do
      let(:registration) { create(:registration, :complete) }
      let(:recipient) { registration.contact_email }
      let(:reference) { "WEX0123456" }

      subject(:run_service) { described_class.run(registration: registration, recipient: recipient) }

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:a_registration) { create(:registration, :complete) }
        let(:parameters) { { registration: a_registration, recipient: a_registration.contact_email } }
      end

      before do
        allow(registration).to receive(:reference).and_return(reference)
      end

      it "sends an email" do
        VCR.use_cassette("registration_edit_confirmation_email") do
          expect(run_service).to be_a(Notifications::Client::ResponseNotification)
        end
      end

      it "uses the expected Notify template" do
        VCR.use_cassette("registration_edit_confirmation_email") do
          expect(run_service.template["id"]).to eq("5426314f-98ef-419e-a66e-9522ba03f362")
        end
      end

      it "the email has the expected subject" do
        VCR.use_cassette("registration_edit_confirmation_email") do
          expect(run_service.content["subject"]).to eq("Waste exemptions registration #{reference} edit confirmation")
        end
      end
    end
  end
end
