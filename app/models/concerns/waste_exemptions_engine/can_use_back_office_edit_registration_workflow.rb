# frozen_string_literal: true

module WasteExemptionsEngine
  module CanUseBackOfficeEditRegistrationWorkflow
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :workflow_state do
        # States / forms
        # You cannot edit business_type or exemptions, so these are not in the edit journey.

        # Start
        state :back_office_edit_form, initial: true

        # Applicant details
        state :applicant_name_form
        state :applicant_phone_form
        state :applicant_email_form

        # Operator details
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
        state :on_a_farm_form
        state :is_a_farmer_form

        # Site questions
        state :site_grid_reference_form
        state :site_postcode_form
        state :site_address_lookup_form

        # End pages
        state :declaration_form
        state :back_office_edit_complete_form

        # Cancelling
        state :confirm_back_office_edit_cancelled_form
        state :back_office_edit_cancelled_form

        ## Transitions

        # Applicant details

        event :edit_applicant_name do
          transitions from: :back_office_edit_form,
                      to: :applicant_name_form
        end

        event :edit_applicant_phone do
          transitions from: :back_office_edit_form,
                      to: :applicant_phone_form
        end

        event :edit_applicant_email do
          transitions from: :back_office_edit_form,
                      to: :applicant_email_form
        end

        # Operator details

        event :edit_main_people do
          transitions from: :back_office_edit_form,
                      to: :main_people_form
        end

        event :edit_registration_number do
          transitions from: :back_office_edit_form,
                      to: :registration_number_form
        end

        event :edit_operator_name do
          transitions from: :back_office_edit_form,
                      to: :operator_name_form
        end

        event :edit_operator_postcode do
          transitions from: :back_office_edit_form,
                      to: :operator_postcode_form
        end

        # Contact details

        event :edit_contact_name do
          transitions from: :back_office_edit_form,
                      to: :contact_name_form
        end

        event :edit_contact_position do
          transitions from: :back_office_edit_form,
                      to: :contact_position_form
        end

        event :edit_contact_phone do
          transitions from: :back_office_edit_form,
                      to: :contact_phone_form
        end

        event :edit_contact_email do
          transitions from: :back_office_edit_form,
                      to: :contact_email_form
        end

        event :edit_contact_postcode do
          transitions from: :back_office_edit_form,
                      to: :contact_postcode_form
        end

        # Farm questions

        event :edit_on_a_farm do
          transitions from: :back_office_edit_form,
                      to: :on_a_farm_form
        end

        event :edit_is_a_farmer do
          transitions from: :back_office_edit_form,
                      to: :is_a_farmer_form
        end

        # Site questions

        event :edit_site_grid_reference do
          transitions from: :back_office_edit_form,
                      to: :site_grid_reference_form
        end

        # Cancellation

        event :cancel_edit do
          transitions from: :back_office_edit_form,
                      to: :confirm_back_office_edit_cancelled_form
        end

        # Next transitions once you're on a form

        event :next do
          # Addresses
          transitions from: :operator_postcode_form,
                      to: :operator_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :operator_postcode_form,
                      to: :operator_address_lookup_form

          transitions from: :operator_address_lookup_form,
                      to: :operator_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :contact_postcode_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :contact_postcode_form,
                      to: :contact_address_lookup_form

          transitions from: :contact_address_lookup_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :site_postcode_form,
                      to: :site_address_lookup_form

          # Completing the edit process
          transitions from: :back_office_edit_form,
                      to: :declaration_form

          transitions from: :declaration_form,
                      to: :back_office_edit_complete_form

          # Cancelling the edit process
          transitions from: :confirm_back_office_edit_cancelled_form,
                      to: :back_office_edit_cancelled_form

          # Everything else should always return to edit
          transitions from: %i[applicant_name_form
                               applicant_phone_form
                               applicant_email_form
                               business_type_form
                               main_people_form
                               registration_number_form
                               operator_name_form
                               operator_postcode_form
                               operator_address_lookup_form
                               operator_address_manual_form
                               contact_name_form
                               contact_position_form
                               contact_phone_form
                               contact_email_form
                               contact_postcode_form
                               contact_address_lookup_form
                               contact_address_manual_form
                               on_a_farm_form
                               is_a_farmer_form
                               site_grid_reference_form
                               site_address_lookup_form
                               exemptions_form],
                      to: :back_office_edit_form
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
                      to: :site_postcode_form
        end
      end
    end

    private

    def skip_to_manual_address?
      address_finder_error
    end
  end
end
