# frozen_string_literal: true

module WasteExemptionsEngine
  module CanUseRenewingRegistrationWorkflow
    extend ActiveSupport::Concern

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
        state :confirm_renewal_form

        # Exemptions
        state :exemptions_form
        state :edit_exemptions_form
        state :confirm_edit_exemptions_form
        state :renew_exemptions_form
        state :renew_no_exemptions_form

        # Applicant details
        state :applicant_name_form
        state :applicant_phone_form
        state :applicant_email_form

        # Operator details
        state :main_people_form
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
        state :on_a_farm_form
        state :is_a_farmer_form

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
                      to: :confirm_renewal_form

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
                      to: :edit_exemptions_declaration_form,
                      if: :exemption_edits_confirmed?

          transitions from: :confirm_edit_exemptions_form,
                      to: :edit_exemptions_form

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

          # Operator details
          transitions from: :operator_postcode_form,
                      to: :operator_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :operator_postcode_form,
                      to: :operator_address_lookup_form

          transitions from: :operator_address_lookup_form,
                      to: :operator_address_manual_form,
                      if: :skip_to_manual_address?

          # Contact details
          transitions from: :contact_postcode_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :contact_postcode_form,
                      to: :contact_address_lookup_form

          transitions from: :contact_address_lookup_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :check_your_answers_form,
                      to: :declaration_form

          transitions from: :declaration_form,
                      to: :renewal_complete_form

          # Renew without changes jumps to declaration form
          transitions from: :confirm_renewal_form,
                      to: :declaration_form

          # Check Your Answers
          transitions from: %i[
                        exemptions_form
                        applicant_name_form
                        applicant_phone_form
                        applicant_email_form
                        contact_address_lookup_form
                        contact_address_manual_form
                        contact_name_form
                        contact_phone_form
                        contact_email_form
                        contact_position_form
                        on_a_farm_form
                        is_a_farmer_form
                        operator_address_lookup_form
                        operator_address_manual_form
                      ],
                      to: :renewal_start_form
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

        event :edit_exemptions do
          transitions from: :renewal_start_form,
                      to: :exemptions_form
        end

        event :edit_applicant_name do
          transitions from: :renewal_start_form,
                      to: :applicant_name_form
        end

        event :edit_applicant_phone do
          transitions from: :renewal_start_form,
                      to: :applicant_phone_form
        end

        event :edit_applicant_email do
          transitions from: :renewal_start_form,
                      to: :applicant_email_form
        end

        event :edit_contact_address do
          transitions from: :renewal_start_form,
                      to: :contact_postcode_form
        end

        event :edit_contact_name do
          transitions from: :renewal_start_form,
                      to: :contact_name_form
        end

        event :edit_contact_phone do
          transitions from: :renewal_start_form,
                      to: :contact_phone_form
        end

        event :edit_contact_email do
          transitions from: :renewal_start_form,
                      to: :contact_email_form
        end

        event :edit_contact_position do
          transitions from: :renewal_start_form,
                      to: :contact_position_form
        end

        event :edit_on_a_farm do
          transitions from: :renewal_start_form,
                      to: :on_a_farm_form
        end

        event :edit_is_a_farmer do
          transitions from: :renewal_start_form,
                      to: :is_a_farmer_form
        end

        event :edit_operator_address do
          transitions from: :renewal_start_form,
                      to: :operator_postcode_form
        end
      end
    end

    private

    def any_exemptions_selected?
      exemptions.any?
    end

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

    def skip_to_manual_address?
      address_finder_error
    end

    def companies_house_details_incorrect?
      temp_use_registered_company_details == false
    end

    def exemption_edits_confirmed?
      temp_confirm_exemption_edits == true
    end

    def all_exemptions_deregistered?
      excluded_exemptions.length == registration.exemptions.length
    end

    def no_exemptions_deregistered?
      excluded_exemptions.empty?
    end

    # def check_your_answers_flow?
    #   # byebug
    #   temp_check_your_answers_flow == true
    #   true
    # end
  end
end
