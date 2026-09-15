# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ProofOfPaymentLetterService do
    subject(:run_service) { described_class.run(registration:) }

    let(:registration) do
      create(:registration,
             contact_first_name: "Jo",
             contact_last_name: "Bloggs",
             addresses: [build(:address, :contact_address, :postal, postcode: "BS1 1AA")])
    end
    let(:personalisation) { { reg_identifier: registration.reference } }
    let(:presenter) { instance_double(ProofOfPaymentPresenter, personalisation:) }
    let(:client) { instance_double(Notifications::Client) }

    before do
      allow(ProofOfPaymentPresenter).to receive(:new).with(registration:).and_return(presenter)
      allow(Notifications::Client).to receive(:new).and_return(client)
      allow(client).to receive(:send_letter)
    end

    it "sends the proof of payment letter using the new template and postal address" do
      run_service

      expect(client).to have_received(:send_letter).with(
        template_id: NotificationTemplates::PROOF_OF_PAYMENT_LETTER,
        personalisation: hash_including(personalisation.merge(
                                          "address_line_1" => "Jo Bloggs",
                                          "address_line_6" => "BS1 1AA"
                                        ))
      )
    end

    it "records the communication" do
      aggregate_failures do
        expect { run_service }.to change(CommunicationLog, :count).by(1)

        expect(registration.communication_logs.last).to have_attributes(
          message_type: "letter",
          template_id: NotificationTemplates::PROOF_OF_PAYMENT_LETTER,
          template_label: "Proof of payment letter"
        )
      end
    end
  end
end
