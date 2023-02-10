# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class RegistrationEditConfirmationEmailService < BaseService
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
        template_id: "5426314f-98ef-419e-a66e-9522ba03f362",
        personalisation: {
          reference: @registration.reference,
          exemptions: @registration.registration_exemptions
        }
      }
    end
  end
end
