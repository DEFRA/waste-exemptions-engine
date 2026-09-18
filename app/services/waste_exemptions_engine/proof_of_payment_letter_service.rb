# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class ProofOfPaymentLetterService < BaseService
    include ApplicationHelper
    include CanHaveCommunicationLog

    def run(registration:)
      @registration = registration

      result = Notifications::Client
               .new(WasteExemptionsEngine.configuration.notify_api_key)
               .send_letter(template_id: NotificationTemplates::PROOF_OF_PAYMENT_LETTER,
                            personalisation: personalisation)

      create_log(registration:, notify_response: result)

      result
    end

    def communications_log_params
      {
        message_type: "letter",
        template_id: NotificationTemplates::PROOF_OF_PAYMENT_LETTER,
        template_label: "Proof of payment letter",
        sent_to: recipient
      }
    end

    private

    def personalisation
      ProofOfPaymentPresenter.new(registration: @registration).personalisation.merge(address_lines)
    end

    def address_values
      [
        "#{@registration.contact_first_name} #{@registration.contact_last_name}",
        displayable_address(@registration.contact_address)
      ].flatten
    end

    def address_lines
      address_values.each_with_index.to_h do |value, index|
        ["address_line_#{index + 1}", value]
      end
    end

    def recipient
      address_values.join(", ")
    end
  end
end
