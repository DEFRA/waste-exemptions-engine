# frozen_string_literal: true

module WasteExemptionsEngine
  module CanUseNewRegistrationWorkflow
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :workflow_state do
        # States / forms

        # Start
        state :start_form, initial: true

        # Capture registration data
        state :capture_reference_form
        state :capture_email_form
        state :capture_complete_form

        # Location
        state :location_form
        state :register_in_northern_ireland_form
        state :register_in_scotland_form
        state :register_in_wales_form

        # Applicant details
        state :applicant_name_form
        state :applicant_phone_form
        state :applicant_email_form

        # Operator details
        state :business_type_form
        state :main_people_form
        state :registration_number_form
        state :check_registered_name_and_address_form
        state :incorrect_company_form
        state :operator_name_form
        state :operator_postcode_form
        state :operator_address_lookup_form
        state :operator_address_manual_form

        # Contact details
        state :check_contact_name_form
        state :contact_name_form
        state :contact_position_form
        state :check_contact_phone_form
        state :contact_phone_form
        state :check_contact_email_form
        state :contact_email_form
        state :check_contact_address_form
        state :contact_postcode_form
        state :contact_address_lookup_form
        state :contact_address_manual_form

        # Farm questions
        state :on_a_farm_form
        state :is_a_farmer_form

        # Site questions
        state :site_grid_reference_form
        state :check_site_address_form
        state :site_postcode_form
        state :site_address_lookup_form

        state :exemptions_form

        # End pages
        state :check_your_answers_form
        state :declaration_form
        state :registration_complete_form

        # Transitions
        event :next do
          # Start
          transitions from: :start_form,
                      to: :capture_reference_form,
                      if: :should_edit?

          transitions from: :start_form,
                      to: :location_form

          transitions from: :start_form,
                      to: :capture_reference_form

          # Registration lookup
          transitions from: :capture_reference_form,
                      to: :capture_email_form

          # Registration lookup confirmation
          transitions from: :capture_email_form,
                      to: :capture_complete_form

          # Location
          transitions from: :location_form,
                      to: :register_in_northern_ireland_form,
                      if: :should_register_in_northern_ireland?

          transitions from: :location_form,
                      to: :register_in_scotland_form,
                      if: :should_register_in_scotland?

          transitions from: :location_form,
                      to: :register_in_wales_form,
                      if: :should_register_in_wales?

          transitions from: :location_form,
                      to: :exemptions_form

          # Exemptions
          transitions from: :exemptions_form,
                      to: :applicant_name_form

          # Applicant details
          transitions from: :applicant_name_form,
                      to: :applicant_phone_form

          transitions from: :applicant_phone_form,
                      to: :applicant_email_form

          transitions from: :applicant_email_form,
                      to: :business_type_form

          # Operator details
          transitions from: :business_type_form,
                      to: :main_people_form,
                      if: :partnership?

          transitions from: :business_type_form,
                      to: :operator_name_form,
                      if: :skip_registration_number?

          transitions from: :business_type_form,
                      to: :registration_number_form

          transitions from: :main_people_form,
                      to: :operator_name_form

          transitions from: :registration_number_form,
                      to: :check_registered_name_and_address_form

          transitions from: :check_registered_name_and_address_form,
                      to: :incorrect_company_form,
                      if: :companies_house_details_incorrect?

          transitions from: :check_registered_name_and_address_form,
                      to: :operator_postcode_form

          transitions from: :incorrect_company_form,
                      to: :registration_number_form

          transitions from: :operator_name_form,
                      to: :operator_postcode_form

          transitions from: :operator_postcode_form,
                      to: :operator_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :operator_postcode_form,
                      to: :operator_address_lookup_form

          transitions from: :operator_address_lookup_form,
                      to: :operator_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :operator_address_lookup_form,
                      to: :check_contact_name_form

          transitions from: :operator_address_manual_form,
                      to: :check_contact_name_form

          # Contact details
          transitions from: :check_contact_name_form,
                      to: :contact_name_form,
                      unless: :temp_reuse_applicant_name?

          transitions from: :check_contact_name_form,
                      to: :contact_position_form

          transitions from: :contact_name_form,
                      to: :contact_position_form

          transitions from: :contact_position_form,
                      to: :check_contact_phone_form

          transitions from: :check_contact_phone_form,
                      to: :contact_phone_form,
                      unless: :temp_reuse_applicant_phone?

          transitions from: :check_contact_phone_form,
                      to: :contact_email_form,
                      unless: :applicant_email?

          transitions from: :check_contact_phone_form,
                      to: :check_contact_email_form

          transitions from: :contact_phone_form,
                      to: :contact_email_form,
                      unless: :applicant_email

          transitions from: :contact_phone_form,
                      to: :check_contact_email_form

          transitions from: :check_contact_email_form,
                      to: :contact_email_form,
                      unless: :temp_reuse_applicant_email?

          transitions from: :check_contact_email_form,
                      to: :check_contact_address_form,
                      if: :temp_reuse_applicant_email?

          transitions from: :contact_email_form,
                      to: :check_contact_address_form

          transitions from: :check_contact_address_form,
                      to: :contact_postcode_form,
                      unless: :temp_reuse_operator_address?

          transitions from: :check_contact_address_form,
                      to: :on_a_farm_form,
                      if: :temp_reuse_operator_address?

          transitions from: :contact_postcode_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :contact_postcode_form,
                      to: :contact_address_lookup_form

          transitions from: :contact_address_lookup_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :contact_address_lookup_form,
                      to: :on_a_farm_form

          transitions from: :contact_address_manual_form,
                      to: :on_a_farm_form

          # Farm questions
          transitions from: :on_a_farm_form,
                      to: :is_a_farmer_form

          # Site questions
          transitions from: :is_a_farmer_form,
                      to: :site_grid_reference_form

          transitions from: :site_grid_reference_form,
                      to: :check_site_address_form,
                      if: :skip_to_manual_address?

          transitions from: :site_grid_reference_form,
                      to: :check_your_answers_form

          transitions from: :check_site_address_form,
                      to: :site_postcode_form,
                      unless: :reuse_address_for_site_location?

          transitions from: :check_site_address_form,
                      to: :check_your_answers_form

          transitions from: :site_postcode_form,
                      to: :site_address_lookup_form

          transitions from: :site_address_lookup_form,
                      to: :check_your_answers_form

          transitions from: :site_address_lookup_form,
                      to: :site_grid_reference_form

          transitions from: :check_your_answers_form,
                      to: :declaration_form

          transitions from: :declaration_form,
                      to: :registration_complete_form
        end

        event :skip_to_manual_address do
          transitions from: :operator_postcode_form,
                      to: :operator_address_manual_form

          transitions from: :operator_address_lookup_form,
                      to: :operator_address_manual_form

          transitions from: :contact_postcode_form,
                      to: :contact_address_manual_form

          transitions from: :contact_address_lookup_form,
                      to: :contact_address_manual_form
        end

        event :skip_to_address do
          transitions from: :site_grid_reference_form,
                      to: :check_site_address_form
        end
      end
    end

    private

    def operator_address_was_manually_entered?
      return false unless operator_address

      # We use the mode field to record whether the address was manually entered
      # and because it correlates to an enum, Activerecord magic gives us
      # my_address.manual?
      operator_address.manual?
    end

    def contact_address_was_manually_entered?
      return false unless contact_address

      contact_address.manual?
    end

    def site_address_was_manually_entered?
      return false unless site_address

      site_address.manual?
    end

    def site_address_was_entered?
      return false unless site_address

      site_address.lookup?
    end

    def reuse_address_for_site_location?
      return true if %w[operator_address_option contact_address_option].include? temp_reuse_address_for_site_location

      false
    end

    def should_edit?
      start_option == "edit"
    end

    def should_register_in_northern_ireland?
      location == "northern_ireland"
    end

    def should_register_in_scotland?
      location == "scotland"
    end

    def should_register_in_wales?
      location == "wales"
    end

    def skip_registration_number?
      return false if company_no_required?

      true
    end

    def skip_to_manual_address?
      address_finder_error
    end

    def companies_house_details_incorrect?
      temp_use_registered_company_details == false
    end
  end
end
