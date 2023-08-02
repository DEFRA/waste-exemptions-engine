# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendRegistrationEditEmailJob do

  describe "#perform" do
    subject(:run_job) { described_class.new.perform(reference: registration.reference, email: email) }

    let(:email) { Faker::Internet.email }
    let(:registration) { create(:registration) }
    let(:notifications_client) { instance_double(Notifications::Client) }
    let(:template_label) { I18n.t("template_labels.registration_edit_email") }

    before do
      allow(WasteExemptionsEngine::RegistrationEditLinkEmailService).to receive(:run).with(anything).and_call_original
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(notifications_client).to receive(:send_email)
    end

    context "when reference and email provided are matching one of the existing registrations" do
      before { registration.update!(contact_email: email) }

      it "sends the email" do
        run_job

        expect(WasteExemptionsEngine::RegistrationEditLinkEmailService)
          .to have_received(:run)
          .with(registration: registration, recipient: registration.contact_email)
          .once
      end
    end

    context "when reference and email provided do not match any of existing registrations" do
      it "does not send the email" do

        run_job

        expect(WasteExemptionsEngine::RegistrationEditLinkEmailService)
          .not_to have_received(:run)
      end
    end
  end
end
