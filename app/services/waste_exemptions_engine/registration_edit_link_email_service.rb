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

      create_log(registration:, notify_response: notify_result)

      notify_result
    end

    # For CanHaveCommunicationLog
    def communications_log_params
      {
        message_type: "email",
        template_id: template_id,
        template_label: template_label,
        sent_to: @recipient
      }
    end

    private

    def template_id
      if @registration.multisite?
        NotificationTemplates::REGISTRATION_EDIT_LINK_MULTI_SITE_EMAIL
      else
        NotificationTemplates::REGISTRATION_EDIT_LINK_EMAIL
      end
    end

    def template_label
      if @registration.multisite?
        "Registration edit link multi-site email"
      else
        "Registration edit link email"
      end
    end

    def options
      {
        email_address: @recipient,
        template_id: template_id,
        personalisation: personalisation
      }
    end

    def personalisation
      base = {
        reference: @registration.reference,
        contact_name: @registration.contact_name,
        magic_link_url: magic_link_url,
        exemptions: active_exemptions_text
      }

      if @registration.multisite?
        base.merge(sites: @registration.multisite_location_section)
      else
        base.merge(site_details: @registration.location_section)
      end
    end

    def magic_link_url
      Rails.configuration.front_office_url +
        WasteExemptionsEngine::Engine.routes.url_helpers.validate_edit_token_path(edit_token: @magic_link_token)
    end

    def active_exemptions_text
      WasteExemptionsEngine::Exemption
        .joins(:registration_exemptions)
        .merge(@registration.registration_exemptions.active)
        .distinct
        .map { |exemption| exemption_row(exemption) }
    end

    def exemption_row(exemption)
      "#{exemption.code} #{exemption.summary}"
    end
  end
end
