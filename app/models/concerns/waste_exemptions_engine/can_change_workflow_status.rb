# frozen_string_literal: true

# We believe in the case of the different states and transitions for the
# exemption journey, its better to see them all in one place. However this
# does mean the module length breaks rubocops rules hence the exception.
# rubocop:disable Metrics/ModuleLength
module WasteExemptionsEngine
  module CanChangeWorkflowStatus
    extend ActiveSupport::Concern

    # We believe in the case of the different states and transitions for the
    # exemption journey, its better to see them all in one place. However this
    # does mean the block length breaks rubocops rules hence the exception.
    # rubocop:disable Metrics/BlockLength
    included do
      include AASM

      aasm column: :workflow_state do
        # States / forms

        # Start
        state :start_form, initial: true
        state :contact_agency_form

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
        state :operator_name_form
        state :operator_postcode_form
        state :operator_address_lookup_form
        state :operator_address_manual_form

        # Contact details
        state :contact_name_form
        state :contact_position_form
        state :contact_phone_form
        state :contact_email_form
        state :contact_postcode_form
        state :contact_address_lookup_form
        state :contact_address_manual_form

        # Farm questions
        state :is_a_farm_form
        state :is_a_farmer_form

        # Site questions
        state :site_grid_reference_form
        state :site_postcode_form
        state :site_address_lookup_form
        state :site_address_manual_form

        state :exemptions_form

        # End pages
        state :check_your_answers_form
        state :declaration_form
        state :registration_complete_form

        # Transitions
        event :next do
          # Start
          transitions from: :start_form,
                      to: :contact_agency_form,
                      if: :should_contact_the_agency?

          transitions from: :start_form,
                      to: :location_form

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
                      to: :operator_name_form

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
                      to: :contact_name_form

          transitions from: :operator_address_manual_form,
                      to: :contact_name_form

          # Contact details
          transitions from: :contact_name_form,
                      to: :contact_position_form

          transitions from: :contact_position_form,
                      to: :contact_phone_form

          transitions from: :contact_phone_form,
                      to: :contact_email_form

          transitions from: :contact_email_form,
                      to: :contact_postcode_form

          transitions from: :contact_postcode_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :contact_postcode_form,
                      to: :contact_address_lookup_form

          transitions from: :contact_address_lookup_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :contact_address_lookup_form,
                      to: :is_a_farm_form

          transitions from: :contact_address_manual_form,
                      to: :is_a_farm_form

          # Farm questions
          transitions from: :is_a_farm_form,
                      to: :is_a_farmer_form

          # Site questions
          transitions from: :is_a_farmer_form,
                      to: :site_grid_reference_form

          transitions from: :site_grid_reference_form,
                      to: :site_postcode_form,
                      if: :skip_to_manual_address?

          transitions from: :site_grid_reference_form,
                      to: :exemptions_form

          transitions from: :site_postcode_form,
                      to: :site_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :site_postcode_form,
                      to: :site_address_lookup_form

          transitions from: :site_address_lookup_form,
                      to: :site_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :site_address_lookup_form,
                      to: :exemptions_form

          transitions from: :site_address_manual_form,
                      to: :exemptions_form

          transitions from: :exemptions_form,
                      to: :check_your_answers_form

          transitions from: :check_your_answers_form,
                      to: :declaration_form

          transitions from: :declaration_form,
                      to: :registration_complete_form
        end

        event :back do
          # Start
          transitions from: :contact_agency_form,
                      to: :start_form

          # Location
          transitions from: :location_form,
                      to: :start_form

          transitions from: :register_in_northern_ireland_form,
                      to: :location_form

          transitions from: :register_in_scotland_form,
                      to: :location_form

          transitions from: :register_in_wales_form,
                      to: :location_form

          # Applicant details
          transitions from: :applicant_name_form,
                      to: :location_form

          transitions from: :applicant_phone_form,
                      to: :applicant_name_form

          transitions from: :applicant_email_form,
                      to: :applicant_phone_form

          transitions from: :business_type_form,
                      to: :applicant_email_form

          # Operator details
          transitions from: :main_people_form,
                      to: :business_type_form

          transitions from: :registration_number_form,
                      to: :business_type_form

          transitions from: :operator_name_form,
                      to: :main_people_form,
                      if: :partnership?

          transitions from: :operator_name_form,
                      to: :business_type_form,
                      if: :skip_registration_number?

          transitions from: :operator_name_form,
                      to: :registration_number_form

          transitions from: :operator_postcode_form,
                      to: :operator_name_form

          transitions from: :operator_address_lookup_form,
                      to: :operator_postcode_form

          transitions from: :operator_address_manual_form,
                      to: :operator_postcode_form

          # Contact details
          transitions from: :contact_name_form,
                      to: :operator_address_manual_form,
                      if: :operator_address_was_manually_entered?

          transitions from: :contact_name_form,
                      to: :operator_address_lookup_form

          transitions from: :contact_position_form,
                      to: :contact_name_form

          transitions from: :contact_phone_form,
                      to: :contact_position_form

          transitions from: :contact_email_form,
                      to: :contact_phone_form

          transitions from: :contact_postcode_form,
                      to: :contact_email_form

          transitions from: :contact_address_lookup_form,
                      to: :contact_postcode_form

          transitions from: :contact_address_manual_form,
                      to: :contact_postcode_form

          # Farm questions
          transitions from: :is_a_farm_form,
                      to: :contact_address_manual_form,
                      if: :contact_address_was_manually_entered?

          transitions from: :is_a_farm_form,
                      to: :contact_address_lookup_form

          transitions from: :is_a_farmer_form,
                      to: :is_a_farm_form

          # Site questions
          transitions from: :site_grid_reference_form,
                      to: :is_a_farmer_form

          transitions from: :site_postcode_form,
                      to: :site_grid_reference_form

          transitions from: :site_address_lookup_form,
                      to: :site_postcode_form

          transitions from: :site_address_manual_form,
                      to: :site_postcode_form

          # Exemptions questions
          transitions from: :exemptions_form,
                      to: :site_address_manual_form,
                      if: :site_address_was_manually_entered?

          transitions from: :exemptions_form,
                      to: :site_address_lookup_form,
                      if: :site_address_was_entered?

          transitions from: :exemptions_form,
                      to: :site_grid_reference_form

          # End pages
          transitions from: :check_your_answers_form,
                      to: :exemptions_form

          transitions from: :declaration_form,
                      to: :check_your_answers_form
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

          transitions from: :site_postcode_form,
                      to: :site_address_manual_form

          transitions from: :site_address_lookup_form,
                      to: :site_address_manual_form
        end

        event :skip_to_address do
          transitions from: :site_grid_reference_form,
                      to: :site_postcode_form
        end
      end
    end
    # rubocop:enable Metrics/BlockLength

    private

    def operator_address_was_manually_entered?
      return unless operator_address

      # We use the mode field to record whether the address was manually entered
      # and because it correlates to an enum, Activerecord magic gives us
      # my_address.manual?
      operator_address.manual?
    end

    def contact_address_was_manually_entered?
      return unless contact_address

      contact_address.manual?
    end

    def site_address_was_manually_entered?
      return unless site_address

      site_address.manual?
    end

    def site_address_was_entered?
      return unless site_address

      site_address.lookup?
    end

    def should_contact_the_agency?
      start_option == "change"
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
  end
end
# rubocop:enable Metrics/ModuleLength
