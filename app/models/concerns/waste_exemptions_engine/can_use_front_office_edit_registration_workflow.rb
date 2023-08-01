# frozen_string_literal: true

module WasteExemptionsEngine
  module CanUseFrontOfficeEditRegistrationWorkflow
    extend ActiveSupport::Concern

    # rubocop:disable Metrics/BlockLength
    included do
      include AASM

      aasm column: :workflow_state do
        # States / forms

        # Start
        state :front_office_edit_form, initial: true

        # Exemptions
        state :edit_exemptions_form
        state :confirm_edit_exemptions_form

        # Contact details
        state :contact_name_form
        state :contact_phone_form
        state :contact_email_form

        # End pages
        state :front_office_edit_declaration_form
        state :front_office_edit_complete_form
        state :front_office_edit_complete_no_change_form
        state :front_office_deregistration_complete_full_form

        ## Edit transitions
        event :edit_exemptions do
          transitions from: :front_office_edit_form,
                      to: :edit_exemptions_form
        end

        event :edit_contact_name do
          transitions from: :front_office_edit_form,
                      to: :contact_name_form
        end

        event :edit_contact_phone do
          transitions from: :front_office_edit_form,
                      to: :contact_phone_form
        end

        event :edit_contact_email do
          transitions from: :front_office_edit_form,
                      to: :contact_email_form
        end

<<<<<<< HEAD
=======

>>>>>>> e17f7fd (Add front-office edit registration form and initial workflow)
        # Next transitions
        event :next do

          # exemptions
          transitions from: :edit_exemptions_form,
                      to: :front_office_edit_form,
                      if: :no_exemptions_deregistered?

          transitions from: :edit_exemptions_form,
                      to: :confirm_edit_exemptions_form

          transitions from: :confirm_edit_exemptions_form,
                      to: :edit_exemptions_form,
                      unless: :exemption_edits_confirmed?

          # Completing the edit process
          transitions from: :front_office_edit_form,
<<<<<<< HEAD
                      to: :front_office_edit_declaration_form

          transitions from: :front_office_edit_declaration_form,
                      to: :deregistration_complete_full_form,
                      if: :all_exemptions_deregistered?

          transitions from: :front_office_edit_declaration_form,
                      to: :front_office_edit_complete_no_change_form,
                      if: :no_changes?

          transitions from: :front_office_edit_declaration_form,
=======
                      to: :front_office_declaration_form

          transitions from: :front_office_declaration_form,
                      to: :deregistration_complete_full_form,
                      if: :all_exemptions_deregistered?

          transitions from: :front_office_declaration_form,
                      to: :front_office_edit_complete_no_change_form,
                      if: :no_changes?

          transitions from: :front_office_declaration_form,
>>>>>>> e17f7fd (Add front-office edit registration form and initial workflow)
                      to: :front_office_edit_complete_form

          # Everything else should always return to the main edit page
          transitions from: %i[
            contact_name_form
            contact_phone_form
            contact_email_form
            confirm_edit_exemptions_form
          ], to: :front_office_edit_form
        end
      end

      # helpers
<<<<<<< HEAD

=======
    
>>>>>>> e17f7fd (Add front-office edit registration form and initial workflow)
      def all_exemptions_deregistered?
        excluded_exemptions.length == registration.exemptions.length
      end

      def no_exemptions_deregistered?
        excluded_exemptions.empty?
      end
<<<<<<< HEAD

      def no_changes?
        !modified?
      end

      def exemption_edits_confirmed?
        temp_confirm_exemption_edits == true
=======
  
      def no_changes?
        excluded_exemptions.empty? && transient_registration_editable_attributes_unchanged
      end

      def exemption_edits_confirmed?
        temp_confirm_exemption_edits == "no"
>>>>>>> e17f7fd (Add front-office edit registration form and initial workflow)
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
