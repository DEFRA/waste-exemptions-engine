# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ProofOfPaymentEmailService do
    subject(:run_service) { described_class.run(registration:, recipient:) }

    let(:registration) { create(:registration) }
    let(:recipient) { "jo.bloggs@example.com" }
    let(:personalisation) { { reg_identifier: registration.reference } }
    let(:presenter) { instance_double(ProofOfPaymentPresenter, personalisation:) }
    let(:client) { instance_double(Notifications::Client) }

    before do
      allow(ProofOfPaymentPresenter).to receive(:new).with(registration:).and_return(presenter)
      allow(Notifications::Client).to receive(:new).and_return(client)
      allow(client).to receive(:send_email)
    end

    it "sends the proof of payment email using the new template" do
      run_service

      expect(client).to have_received(:send_email).with(
        email_address: recipient,
        template_id: NotificationTemplates::PROOF_OF_PAYMENT_EMAIL,
        personalisation:
      )
    end

    it "records the communication" do
      aggregate_failures do
        expect { run_service }.to change(CommunicationLog, :count).by(1)

        expect(registration.communication_logs.last).to have_attributes(
          message_type: "email",
          template_id: NotificationTemplates::PROOF_OF_PAYMENT_EMAIL,
          template_label: "Proof of payment email",
          sent_to: recipient
        )
      end
    end
  end
end
