# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class RegistrationEditConfirmationEmailService < BaseService
    include CanHaveCommunicationLog

    def run(registration:, recipient:)
      @registration = registration
      @recipient = recipient

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
        template_label: "Registration edit confirmation email",
        sent_to: @recipient
      }
    end

    private

    def template_id
      "5426314f-98ef-419e-a66e-9522ba03f362"
    end

    def options
      {
        email_address: @recipient,
        template_id: template_id,
        personalisation: {
          reference: @registration.reference,
          exemptions: active_exemptions_text
        }
      }
    end

    def active_exemptions_text
      @registration.registration_exemptions.active.map { |re| exemption_row(re.exemption) }
    end

    def exemption_row(exemption)
      "#{exemption.code} #{exemption.summary}"
    end
  end
end
