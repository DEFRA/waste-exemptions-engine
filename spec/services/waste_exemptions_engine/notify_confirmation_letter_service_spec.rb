# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NotifyConfirmationLetterService do

    describe "run" do
      subject(:run_service) { described_class.run(registration: registration) }

      let(:registration) { create(:registration, :complete, :with_active_exemptions) }
      let(:notifications_client) { instance_double(Notifications::Client) }
      let(:mock_response) do
        instance_double(Notifications::Client::ResponseNotification,
                        id: SecureRandom.uuid,
                        content: { "body" => "Letter content", "subject" => "Letter subject" })
      end

      before do
        allow(Notifications::Client).to receive(:new).and_return(notifications_client)
        allow(notifications_client).to receive(:send_letter).and_return(mock_response)
      end

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:a_registration) { create(:registration, :complete, :with_active_exemptions) }
        let(:parameters) { { registration: a_registration } }
      end

      it_behaves_like "calls notify with reference" do
        let(:send_action) { :send_letter }
        let(:reference) { registration.reference }
      end

      it "sends a letter with the correct template" do
        run_service

        expect(notifications_client).to have_received(:send_letter).with(
          hash_including(template_id: WasteExemptionsEngine::NotificationTemplates::CONFIRMATION_LETTER)
        )
      end

      it "does not include applicant fields in personalisation" do
        run_service

        expect(notifications_client).not_to have_received(:send_letter).with(hash_including(personalisation: hash_including(:applicant_name, :applicant_email, :applicant_phone)))
      end
    end
  end
end
