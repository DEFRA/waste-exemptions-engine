# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class ProofOfPaymentEmailService < BaseService
    include CanHaveCommunicationLog

    def run(registration:, recipient:)
      @registration = registration
      @recipient = recipient

      result = Notifications::Client
               .new(WasteExemptionsEngine.configuration.notify_api_key)
               .send_email(options)

      create_log(registration:, notify_response: result)

      result
    end

    def communications_log_params
      {
        message_type: "email",
        template_id: NotificationTemplates::PROOF_OF_PAYMENT_EMAIL,
        template_label: "Proof of payment email",
        sent_to: @recipient
      }
    end

    private

    def options
      {
        email_address: @recipient,
        template_id: NotificationTemplates::PROOF_OF_PAYMENT_EMAIL,
        personalisation: ProofOfPaymentPresenter.new(registration: @registration).personalisation
      }
    end
  end
end
