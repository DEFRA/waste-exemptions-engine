# frozen_string_literal: true

module WasteExemptionsEngine
  class DataOverviewPresenter < BasePresenter
    def initialize(transient_registration)
      super(transient_registration, nil)
    end

    def company_rows
      [
        operator_rows,
        contact_rows
      ].flatten
    end

    def registration_rows
      [
        exemptions_row,
        farm_rows,
        applicant_rows,
        site_location_rows
      ].flatten
    end

    private

    def operator_rows
      rows = [business_type_row, operator_name_row]
      rows << company_no_row if company_no_required?
      rows << partners_row if partnership?
      rows += [location_row, operator_address_row]

      rows
    end

    def contact_rows
      [
        contact_name_row,
        contact_position_row,
        contact_address_row,
        contact_phone_row,
        contact_email_row
      ]
    end

    def farm_rows
      [on_a_farm_row, farmer_row?]
    end

    def applicant_rows
      [applicant_name_row, applicant_phone_row, applicant_email_row]
    end

    def site_location_rows
      if site_address&.located_by_grid_reference?
        [grid_reference_row, site_description_row]
      else
        site_address_row
      end
    end

    def business_type_row
      formatted_business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES.key(business_type)

      {
        title: I18n.t("#{company_i18n_scope}.business_type.title"),
        value: I18n.t("#{company_i18n_scope}.business_type.value.#{formatted_business_type}")
      }
    end

    def operator_name_row
      if company_no_required?
        {
          title: I18n.t("#{company_i18n_scope}.business_name.registered_name"),
          value: operator_name
        }
      else
        {
          title: I18n.t("#{company_i18n_scope}.business_name.operator_name.title"),
          value: operator_name,
          change_url: "check-your-answers/operator-name",
          change_link_suffix: I18n.t("#{company_i18n_scope}.business_name.operator_name.change_link_suffix")
        }
      end
    end

    def company_no_row
      {
        title: I18n.t("#{company_i18n_scope}.company_no.title"),
        value: company_no
      }
    end

    def partners_row
      partners_value = transient_people.map { |person| "#{person.first_name} #{person.last_name}" }
                                       .join("<br>")
                                       .html_safe

      {
        title: I18n.t("#{company_i18n_scope}.partners.title"),
        value: partners_value
      }
    end

    def location_row
      {
        title: I18n.t("#{company_i18n_scope}.location.title"),
        value: I18n.t("#{company_i18n_scope}.location.value.#{location}")
      }
    end

    def operator_address_row
      {
        title: I18n.t("#{company_i18n_scope}.operator_address.title"),
        value: displayable_address(operator_address)
      }
    end

    def contact_name_row
      contact_name = "#{contact_first_name} #{contact_last_name}"

      {
        title: I18n.t("#{company_i18n_scope}.contact_name.title"),
        value: contact_name,
        change_url: "check-your-answers/contact-name",
        change_link_suffix: I18n.t("#{company_i18n_scope}.contact_name.change_link_suffix")
      }
    end

    def contact_position_row
      {
        title: I18n.t("#{company_i18n_scope}.contact_position.title"),
        value: contact_position,
        change_url: "check-your-answers/contact-position",
        change_link_suffix: I18n.t("#{company_i18n_scope}.contact_position.change_link_suffix")
      }
    end

    def contact_address_row
      {
        title: I18n.t("#{company_i18n_scope}.contact_address.title"),
        value: displayable_address(contact_address),
        change_url: "check-your-answers/contact-address",
        change_link_suffix: I18n.t("#{company_i18n_scope}.contact_address.change_link_suffix")
      }
    end

    def contact_phone_row
      {
        title: I18n.t("#{company_i18n_scope}.contact_phone.title"),
        value: contact_phone,
        change_url: "check-your-answers/contact-phone",
        change_link_suffix: I18n.t("#{company_i18n_scope}.contact_phone.change_link_suffix")
      }
    end

    def contact_email_row
      {
        title: I18n.t("#{company_i18n_scope}.contact_email.title"),
        value: contact_email,
        change_url: "check-your-answers/contact-email",
        change_link_suffix: I18n.t("#{company_i18n_scope}.contact_email.change_link_suffix")
      }
    end

    def exemptions_row
      exemptions_value = exemptions.map(&:code).join(", ")

      {
        title: I18n.t("#{reg_i18n_scope}.exemptions.title"),
        value: exemptions_value
      }
    end

    def on_a_farm_row
      {
        title: I18n.t("#{reg_i18n_scope}.on_a_farm.title"),
        value: I18n.t("#{reg_i18n_scope}.on_a_farm.value.#{on_a_farm}")
      }
    end

    def farmer_row?
      {
        title: I18n.t("#{reg_i18n_scope}.is_a_farmer.title"),
        value: I18n.t("#{reg_i18n_scope}.is_a_farmer.value.#{is_a_farmer}"),
        change_url: "check-your-answers/is-a-farmer",
        change_link_suffix: I18n.t("#{reg_i18n_scope}.is_a_farmer.change_link_suffix")
      }
    end

    def applicant_name_row
      applicant_name = "#{applicant_first_name} #{applicant_last_name}"

      {
        title: I18n.t("#{reg_i18n_scope}.applicant_name.title"),
        value: applicant_name
      }
    end

    def applicant_phone_row
      {
        title: I18n.t("#{reg_i18n_scope}.applicant_phone.title"),
        value: applicant_phone
      }
    end

    def applicant_email_row
      {
        title: I18n.t("#{reg_i18n_scope}.applicant_email.title"),
        value: applicant_email
      }
    end

    def site_address_row
      {
        title: I18n.t("#{reg_i18n_scope}.site_address.title"),
        value: displayable_address(site_address)
      }
    end

    def grid_reference_row
      {
        title: I18n.t("#{reg_i18n_scope}.grid_reference.title"),
        value: site_address&.grid_reference,
        merged_with: :site_description
      }
    end

    def site_description_row
      {
        title: I18n.t("#{reg_i18n_scope}.site_description.title"),
        value: site_address&.description
      }
    end

    def displayable_address(address)
      [address.organisation, address.premises, address.street_address,
       address.locality, address.city, address.postcode].reject(&:blank?).join("<br>").html_safe
    end

    def company_i18n_scope
      "waste_exemptions_engine.shared.data_overview.company_info"
    end

    def reg_i18n_scope
      "waste_exemptions_engine.shared.data_overview.registration_info"
    end
  end
end
