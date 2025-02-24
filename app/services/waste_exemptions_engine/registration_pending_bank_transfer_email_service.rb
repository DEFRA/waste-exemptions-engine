# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class RegistrationPendingBankTransferEmailService < BaseService
    include CanHaveCommunicationLog
    include FinanceDetailsHelper

    def run(registration:, recipient:)
      return unless registration.account.present?

      @registration = registration
      @recipient = recipient

      client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

      result = client.send_email(options)

      create_log(registration:)

      result
    end

    # For CanHaveCommunicationLog
    def communications_log_params
      {
        message_type: "email",
        template_id: template_id,
        template_label: "Registration pending bank transfer payment email",
        sent_to: @recipient
      }
    end

    private

    def template_id
      "90aef20a-0d44-4b06-8a99-b0afbcdaa406"
    end

    def options
      payment_details_path = "waste_exemptions_engine.registration_received_pending_payment_forms.new"
      {
        email_address: @recipient,
        template_id: template_id,
        personalisation: {
          first_name: @registration.contact_first_name,
          last_name: @registration.contact_last_name,
          account_number: I18n.t("#{payment_details_path}.account_number_value"),
          sort_code: I18n.t("#{payment_details_path}.sort_code_value"),
          payment_due: payment_due,
          iban: I18n.t("#{payment_details_path}.iban"),
          swiftbic: I18n.t("#{payment_details_path}.swift_bic"),
          currency: "Sterling",
          reg_identifier: @registration.reference
        }
      }
    end

    def payment_due
      display_pence_as_pounds_and_cents(@registration.account.balance.abs)
    end
  end
end
