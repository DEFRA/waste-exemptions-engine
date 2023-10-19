# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationDetailsPresenter < BasePresenter

    include WasteExemptionsEngine::CanIterateExemptions

    def date_registered
      # Currently you can only add exemptions when you register, so we can assume they expire at the same time
      registration_exemptions.first.registered_on.to_formatted_s(:day_month_year)
    end

    def applicant_name
      "#{applicant_first_name} #{applicant_last_name}"
    end

    def applicant_email_section
      applicant_email.present? ? applicant_email.to_s : no_email_text
    end

    def contact_name
      "#{contact_first_name} #{contact_last_name}"
    end

    def business_details_section
      items = []

      items << business_type_text

      if partnership?
        people.each_with_index do |person, index|
          items << partners_text(person, index)
        end
      else
        items << business_name_text
        items << company_no_text if company_no.present?
      end

      items << business_address_text

      items
    end

    def contact_details_section
      items = []

      items << contact_name_text
      items << contact_position_text if contact_position.present?
      items << contact_phone_text
      items << contact_email_text if contact_email.present?
      items << no_email_text if contact_email.blank?
      items
    end

    def location_section
      items = []

      if site_address&.located_by_grid_reference?
        items << grid_reference_text
        items << site_details_text
      else
        items << site_address_text
      end

      items
    end

    def exemptions_section
      items = []

      sorted_active_registration_exemptions.each do |registration_exemption|
        items << exemption_text(registration_exemption)
      end

      items
    end

    def deregistered_exemptions_section
      items = []

      sorted_deregistered_registration_exemptions.each do |registration_exemption|
        items << exemption_text(registration_exemption)
      end

      items
    end

    private

    # Business details

    def business_type_text
      human_business_type = I18n.t("waste_exemptions_engine.pdfs.certificate.business_types.#{business_type}")
      label_and_value("business_details.type", human_business_type)
    end

    def partners_text(person, index)
      label_text = I18n.t("notify_confirmation_letter.business_details.partner_enumerator", count: index + 1)
      person_name = "#{person.first_name} #{person.last_name}"

      "#{label_text} #{person_name}"
    end

    def business_name_text
      label_and_value("business_details.name.#{business_type}", operator_name)
    end

    def company_no_text
      label_and_value("business_details.number.#{business_type}", company_no)
    end

    def business_address_text
      address = address_lines(operator_address).join(", ")
      label_and_value("business_details.address.#{business_type}", address)
    end

    # Contact details

    def contact_name_text
      label_and_value("waste_operation_contact.name", contact_name)
    end

    def contact_position_text
      label_and_value("waste_operation_contact.position", contact_position)
    end

    def contact_phone_text
      label_and_value("waste_operation_contact.telephone", contact_phone)
    end

    def contact_email_text
      label_and_value("waste_operation_contact.email", contact_email)
    end

    def no_email_text
      label_text = I18n.t("notify_confirmation_letter.waste_operation_contact.email")
      value = I18n.t("notify_confirmation_letter.waste_operation_contact.no_email")
      "#{label_text} #{value}"
    end

    # Location

    def grid_reference_text
      label_and_value("waste_operation_location.ngr", site_address&.grid_reference)
    end

    def site_details_text
      label_and_value("waste_operation_location.details", site_address&.description)
    end

    def site_address_text
      address = address_lines(site_address).join(", ")
      label_and_value("waste_operation_location.address", address)
    end

    # Exemptions

    def exemption_text(registration_exemption)
      status = registration_exemption_status(registration_exemption)
      "#{registration_exemption.exemption.code}: #{registration_exemption.exemption.summary} – #{status}"
    end

    # Utility methods

    def label_and_value(label, value)
      label_text = I18n.t("notify_confirmation_letter.#{label}")
      "#{label_text} #{value}"
    end

    def address_lines(address)
      return [] unless address

      address_fields = %i[organisation premises street_address locality city postcode]
      address_fields.map { |field| address.public_send(field) }.reject(&:blank?)
    end

    def registration_exemption_status(registration_exemption)
      display_date = if %w[active expired].include?(registration_exemption.state)
                       registration_exemption.expires_on.to_formatted_s(:day_month_year)
                     else
                       registration_exemption.deregistered_at.to_formatted_s(:day_month_year)
                     end

      I18n.t(
        "notify_confirmation_letter.waste_exemptions.status.#{registration_exemption.state}",
        display_date: display_date
      )
    end
  end
end
