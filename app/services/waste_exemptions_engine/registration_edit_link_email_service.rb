# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class RegistrationEditLinkEmailService < BaseService
    include CanHaveCommunicationLog

    def run(registration:, recipient:, magic_link_token:)
      @registration = RegistrationDetailsPresenter.new(registration)
      @recipient = recipient
      @magic_link_token = magic_link_token

      client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

      notify_result = client.send_email(options)

      create_log(registration:)

      notify_result
    end

    # For CanHaveCommunicationLog
    def communications_log_params
      {
        message_type: "email",
        template_id: template_id,
        template_label: "Update your contact details and deregister your waste exemptions",
        sent_to: @recipient
      }
    end

    private

    def template_id
      "09320726-38c6-4989-a831-17c7d4ff37db"
    end

    def options
      {
        email_address: @recipient,
        template_id: template_id,
        personalisation: {
          reference: @registration.reference,
          contact_name: @registration.contact_name,
          site_details: @registration.location_section,
          magic_link_url: magic_link_url,
          exemptions: active_exemptions_text
        }
      }
    end

    def magic_link_url
      Rails.configuration.front_office_url +
        WasteExemptionsEngine::Engine.routes.url_helpers.validate_edit_token_path(edit_token: @magic_link_token)
    end

    def active_exemptions_text
      @registration.registration_exemptions.active.map { |re| exemption_row(re.exemption) }
    end

    def exemption_row(exemption)
      "#{exemption.code} #{exemption.summary}"
    end
  end
end
