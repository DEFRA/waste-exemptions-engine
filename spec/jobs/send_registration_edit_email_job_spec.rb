# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendRegistrationEditEmailJob do

  describe "#perform" do
    subject(:run_job) { described_class.new.perform(reference: registration.reference, email: email) }

    let(:email) { Faker::Internet.email }
    let(:registration) { create(:registration) }
    let(:notifications_client) { instance_double(Notifications::Client) }
    let(:template_label) { I18n.t("template_labels.registration_edit_email") }
    let(:magic_link_token) { registration.edit_token }

    before do
      allow(WasteExemptionsEngine::RegistrationEditLinkEmailService).to receive(:run).with(anything).and_call_original
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(notifications_client).to receive(:send_email)
    end

    context "when reference and email match is successful and contact_email and applicant_email are identical" do
      before { registration.update!(contact_email: email, applicant_email: email) }

      it "sets the edit_link_requested_by attribute" do
        run_job

        expect(registration.reload.edit_link_requested_by).to eq(email)
      end

      it "sends the email" do
        run_job

        expect(WasteExemptionsEngine::RegistrationEditLinkEmailService)
          .to have_received(:run)
          .with(registration:, magic_link_token: registration.reload.edit_token, recipient: registration.contact_email)
          .once
      end
    end

    context "when reference and email match is successful and contact_email and applicant_email are different" do
      before { registration.update!(contact_email: email, applicant_email: Faker::Internet.email) }

      it "sets the edit_link_requested_by attribute" do
        run_job

        expect(registration.reload.edit_link_requested_by).to eq(email)
      end

      it "sends the email to both email addresses" do
        run_job

        current_magic_link_token = registration.reload.edit_token

        aggregate_failures do
          expect(WasteExemptionsEngine::RegistrationEditLinkEmailService)
            .to have_received(:run)
            .with(registration:, magic_link_token: current_magic_link_token, recipient: registration.contact_email)
            .once

          expect(WasteExemptionsEngine::RegistrationEditLinkEmailService)
            .to have_received(:run)
            .with(registration:, magic_link_token: current_magic_link_token, recipient: registration.applicant_email)
            .once
        end
      end
    end

    context "when reference and email provided do not match any of existing registrations" do
      it "does not set the edit_link_requested_by attribute" do
        run_job

        expect(registration.reload.edit_link_requested_by).to be_nil
      end

      it "does not send the email" do
        run_job

        expect(WasteExemptionsEngine::RegistrationEditLinkEmailService)
          .not_to have_received(:run)
      end
    end
  end
end
