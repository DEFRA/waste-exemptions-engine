# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class DeregistrationConfirmationEmailService < BaseService
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
        template_label: "Deregistration confirmation email",
        sent_to: @recipient
      }
    end

    private

    def template_id
      "aea54f90-d36c-4fe7-a589-062446e549ca"
    end

    def options
      {
        email_address: @recipient,
        template_id: template_id,
        personalisation: {
          reference: @registration.reference
        }
      }
    end
  end
end
