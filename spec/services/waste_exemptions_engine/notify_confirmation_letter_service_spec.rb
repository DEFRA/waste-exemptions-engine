# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NotifyConfirmationLetterService do

    describe "run" do
      subject(:service) { described_class.run(registration: registration) }

      let(:registration) { create(:registration, :complete, :with_active_exemptions) }
      let(:notifications_client) { instance_double(Notifications::Client) }
      let(:mock_response) { instance_double(Notifications::Client::ResponseNotification) }

      before do
        allow(Notifications::Client).to receive(:new).and_return(notifications_client)
        allow(notifications_client).to receive(:send_letter).and_return(mock_response)
      end

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:a_registration) { create(:registration, :complete, :with_active_exemptions) }
        let(:parameters) { { registration: a_registration } }
      end

      it "sends a letter with the correct template" do
        service

        expect(notifications_client).to have_received(:send_letter).with(
          hash_including(template_id: "81cae4bd-9f4c-4e14-bf3c-44573cee4f5b")
        )
      end

      it "does not include applicant fields in personalisation" do
        service

        expect(notifications_client).not_to have_received(:send_letter).with(hash_including(personalisation: hash_including(:applicant_name, :applicant_email, :applicant_phone)))
      end
    end
  end
end
