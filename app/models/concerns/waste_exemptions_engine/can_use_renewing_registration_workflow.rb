# frozen_string_literal: true

# We believe in the case of the different states and transitions for the
# renewal journey, it's better to see them all in one place. However this
# does mean the module length breaks Rubocop's rules, hence the exception.
# rubocop:disable Metrics/ModuleLength
module WasteExemptionsEngine
  module CanUseRenewingRegistrationWorkflow
    extend ActiveSupport::Concern

    # We believe in the case of the different states and transitions for the
    # renewal journey, it's better to see them all in one place. However this
    # does mean the block length breaks Rubocop's rules, hence the exception.
    # rubocop:disable Metrics/BlockLength
    included do
      include AASM

      aasm column: :workflow_state do
        # States / forms
        state :renewal_start_form

        initial_state lambda { |model|
          return :edit_exemptions_form unless model.registration.in_renewal_window?

          if model.company_no_required?
            :check_registered_name_and_address_form
          else
            :renewal_start_form
          end
        }

        state :check_registered_name_and_address_form
        state :incorrect_company_form
        state :renew_with_changes_form
        state :renew_without_changes_form

        # Exemptions
        state :edit_exemptions_form
        state :confirm_edit_exemptions_form
        state :renew_exemptions_form
        state :renew_no_exemptions_form

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
        state :operator_name_form
        state :operator_postcode_form
        state :operator_address_lookup_form
        state :operator_address_manual_form
        state :cannot_renew_type_change_form

        # Contact details
        state :contact_name_form
        state :contact_position_form
        state :contact_phone_form
        state :contact_email_form
        state :contact_postcode_form
        state :contact_address_lookup_form
        state :contact_address_manual_form

        # Farm questions
        state :on_a_farm_form
        state :is_a_farmer_form

        # Site questions
        state :site_grid_reference_form
        state :site_postcode_form
        state :site_address_lookup_form

        # deregistration
        state :edit_exemptions_declaration_form
        state :confirm_no_exemption_changes_form

        # End pages
        state :check_your_answers_form
        state :declaration_form
        state :renewal_complete_form
        state :deregistration_complete_full_form
        state :deregistration_complete_partial_form
        state :deregistration_complete_no_change_form

        # Transitions
        event :next do
          transitions from: :check_registered_name_and_address_form,
                      to: :renewal_start_form,
                      unless: :companies_house_details_incorrect?

          transitions from: :check_registered_name_and_address_form,
                      to: :incorrect_company_form

          transitions from: :renewal_start_form,
                      to: :renew_with_changes_form,
                      unless: :should_renew_without_changes?

          transitions from: :renewal_start_form,
                      to: :renew_without_changes_form,
                      if: :should_renew_without_changes?

          transitions from: :renew_with_changes_form,
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
                      to: :renew_exemptions_form

          # Exemptions
          transitions from: :renew_exemptions_form,
                      to: :applicant_name_form,
                      if: :any_exemptions_selected?

          transitions from: :renew_exemptions_form,
                      to: :renew_no_exemptions_form,
                      unless: :any_exemptions_selected?

          transitions from: :edit_exemptions_form,
                      to: :confirm_no_exemption_changes_form,
                      if: :no_exemptions_deregistered?

          transitions from: :edit_exemptions_form,
                      to: :confirm_edit_exemptions_form

          transitions from: :confirm_edit_exemptions_form,
                      to: :edit_exemptions_declaration_form

          transitions from: :edit_exemptions_declaration_form,
                      to: :deregistration_complete_no_change_form,
                      if: :no_exemptions_deregistered?

          transitions from: :confirm_no_exemption_changes_form,
                      to: :edit_exemptions_form

          transitions from: :edit_exemptions_declaration_form,
                      to: :deregistration_complete_full_form,
                      if: :all_exemptions_deregistered?

          transitions from: :edit_exemptions_declaration_form,
                      to: :deregistration_complete_partial_form

          # Applicant details
          transitions from: :applicant_name_form,
                      to: :applicant_phone_form

          transitions from: :applicant_phone_form,
                      to: :applicant_email_form

          transitions from: :applicant_email_form,
                      to: :business_type_form

          # Operator details
          transitions from: :business_type_form,
                      to: :cannot_renew_type_change_form,
                      if: :changing_business_type?

          transitions from: :business_type_form,
                      to: :main_people_form,
                      if: :partnership?

          transitions from: :business_type_form,
                      to: :operator_name_form,
                      if: :skip_registration_number?

          transitions from: :business_type_form,
                      to: :operator_postcode_form

          transitions from: :main_people_form,
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
                      to: :on_a_farm_form

          transitions from: :contact_address_manual_form,
                      to: :on_a_farm_form

          # Farm questions
          transitions from: :on_a_farm_form,
                      to: :is_a_farmer_form

          # Site questions
          transitions from: :is_a_farmer_form,
                      to: :site_grid_reference_form,
                      if: :located_by_grid_reference?

          transitions from: :is_a_farmer_form,
                      to: :site_postcode_form,
                      unless: :located_by_grid_reference?

          transitions from: :site_grid_reference_form,
                      to: :site_postcode_form,
                      if: :skip_to_manual_address?

          transitions from: :site_grid_reference_form,
                      to: :check_your_answers_form

          transitions from: :site_postcode_form,
                      to: :site_address_lookup_form

          transitions from: :site_address_lookup_form,
                      to: :check_your_answers_form

          transitions from: :check_your_answers_form,
                      to: :declaration_form

          transitions from: :declaration_form,
                      to: :renewal_complete_form

          # Renew without changes jumps to declaration form
          transitions from: :renew_without_changes_form,
                      to: :declaration_form
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
      end
    end
    # rubocop:enable Metrics/BlockLength

    private

    def any_exemptions_selected?
      exemptions.any?
    end

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

    def should_renew_without_changes?
      temp_renew_without_changes
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

    def located_by_grid_reference?
      site_address.located_by_grid_reference?
    end

    def skip_to_manual_address?
      address_finder_error
    end

    def companies_house_details_incorrect?
      temp_use_registered_company_details == false
    end

    def all_exemptions_deregistered?
      excluded_exemptions.length == registration.exemptions.length
    end

    def no_exemptions_deregistered?
      excluded_exemptions.empty?
    end
  end
end
# rubocop:enable Metrics/ModuleLength
