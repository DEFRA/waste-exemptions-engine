# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class RegistrationPendingBankTransferLetterService < BaseService
    # So we can use displayable_address()
    include ApplicationHelper
    include CanHaveCommunicationLog
    include FinanceDetailsHelper

    def run(registration:)
      @registration = RegistrationDetailsPresenter.new(registration)

      client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

      notify_result = client.send_letter(template_id: template, personalisation: personalisation)

      create_log(registration:)

      notify_result
    end

    # For CanHaveCommunicationLog
    def communications_log_params
      {
        message_type: "letter",
        template_id: template,
        template_label: "Registration pending bank transfer payment letter",
        sent_to: recipient
      }
    end

    private

    def template
      "b614d958-8e85-4168-8e20-6f924dc47dff"
    end

    def personalisation
      payment_details_path = "waste_exemptions_engine.registration_received_pending_payment_forms.new"
      
      # Create hash with string keys as required by GOV.UK Notify
      {
        "reference" => @registration.reference,
        "first_name" => @registration.contact_first_name,
        "last_name" => @registration.contact_last_name,
        "account_number" => I18n.t("#{payment_details_path}.account_number_value"),
        "sort_code" => I18n.t("#{payment_details_path}.sort_code_value"),
        "payment_due" => payment_due,
        "iban" => I18n.t("#{payment_details_path}.iban"),
        "swiftbic" => I18n.t("#{payment_details_path}.swift_bic"),
        "currency" => "Sterling",
        "reg_identifier" => @registration.reference
      }.merge(address_lines)
    end

    def payment_due
      display_pence_as_pounds_and_cents(@registration.account.balance.abs)
    end

    def address_values
      [
        @registration.contact_name,
        displayable_address(@registration.contact_address)
      ].flatten
    end

    def address_lines
      address_hash = {}

      address_values.each_with_index do |value, index|
        line_number = index + 1
        address_hash["address_line_#{line_number}"] = value
      end

      address_hash
    end

    def recipient
      address_values.join(", ")
    end
  end
end
