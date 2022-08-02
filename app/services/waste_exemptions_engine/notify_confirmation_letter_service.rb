# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class NotifyConfirmationLetterService < BaseService
    # So we can use displayable_address()
    include ApplicationHelper

    def run(registration:)
      @registration = NotifyConfirmationLetterPresenter.new(registration)

      client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

      client.send_letter(template_id: template,
                         personalisation: personalisation)
    end

    private

    def template
      "81cae4bd-9f4c-4e14-bf3c-44573cee4f5b"
    end

    def personalisation
      {
        reference: @registration.reference,
        date_registered: @registration.date_registered,
        applicant_name: @registration.applicant_name,
        applicant_email: @registration.applicant_email_section,
        applicant_phone: @registration.applicant_phone,
        business_details: @registration.business_details_section,
        contact_name: @registration.contact_name,
        contact_details: @registration.contact_details_section,
        site_details: @registration.location_section,
        exemption_details: @registration.exemptions_section,
        deregistered_exemption_details: @registration.deregistered_exemptions_section,
        show_deregistered_exemption_details: @registration.deregistered_exemptions_section.present?
      }.merge(address_lines)
    end

    def address_lines
      address_values = [
        @registration.contact_name,
        displayable_address(@registration.contact_address)
      ].flatten

      address_hash = {}

      address_values.each_with_index do |value, index|
        line_number = index + 1
        address_hash["address_line_#{line_number}"] = value
      end

      address_hash
    end
  end
end
