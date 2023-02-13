# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class DeregistrationConfirmationEmailService < BaseService
    def run(registration:, recipient:)
      @registration = registration
      @recipient = recipient

      client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

      client.send_email(options)
    end

    private

    def options
      {
        email_address: @recipient,
        template_id: "aea54f90-d36c-4fe7-a589-062446e549ca",
        personalisation: {
          reference: @registration.reference
        }
      }
    end
  end
end
