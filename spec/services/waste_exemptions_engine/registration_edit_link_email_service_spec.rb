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

    describe "run with a multi-site registration" do
      let(:registration) { create(:registration, :complete, :multisite) }
      let(:recipient) { registration.contact_email }
      let(:magic_link_token) { registration.edit_token }
      let(:notifications_client) { instance_double(Notifications::Client) }
      let(:send_email_response) do
        instance_double(
          Notifications::Client::ResponseNotification,
          id: "notify-id-123",
          content: { "body" => "body", "subject" => "subject" }
        )
      end

      subject(:run_service) { described_class.run(registration:, recipient:, magic_link_token:) }

      before do
        registration.site_addresses.reload.each_with_index do |address, index|
          address.update!(
            mode: WasteExemptionsEngine::Address.modes[:auto],
            grid_reference: "ST 5833#{index} 7285#{index}",
            description: "Description for site #{index + 1}"
          )
        end

        allow(Notifications::Client).to receive(:new).and_return(notifications_client)
        allow(notifications_client).to receive(:send_email).and_return(send_email_response)
      end

      it "uses the multi-site Notify template" do
        run_service

        expect(notifications_client).to have_received(:send_email).with(
          hash_including(template_id: WasteExemptionsEngine::NotificationTemplates::REGISTRATION_EDIT_LINK_MULTI_SITE_EMAIL)
        )
      end

      it "sends one sites entry per site formatted with grid reference and description" do
        run_service

        expected_entries = registration.site_addresses.map do |address|
          "Location: #{address.grid_reference}\nDescription: #{address.description}"
        end

        expect(notifications_client).to have_received(:send_email).with(
          hash_including(personalisation: hash_including(sites: expected_entries))
        )
      end

      it "does not pass the single-site site_details key" do
        run_service

        expect(notifications_client).to have_received(:send_email).with(
          hash_including(personalisation: satisfy { |p| !p.key?(:site_details) })
        )
      end
    end
  end
end
