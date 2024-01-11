# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module WasteExemptionsEngine
  module CanUseFrontOfficeEditRegistrationWorkflow
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :workflow_state do
        # States / forms

        # Start
        state :front_office_edit_form, initial: true

        # Exemptions
        state :edit_exemptions_form
        state :confirm_edit_exemptions_form
        state :edit_exemptions_declaration_form

        # Contact details
        state :contact_name_form
        state :contact_phone_form
        state :contact_email_form
        state :contact_postcode_form
        state :contact_address_lookup_form
        state :contact_address_manual_form

        # End pages
        state :front_office_edit_declaration_form
        state :front_office_edit_complete_form
        state :front_office_edit_complete_no_changes_form
        state :deregistration_complete_full_form

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

        event :edit_contact_postcode do
          transitions from: :front_office_edit_form,
                      to: :contact_postcode_form
        end

        # Next transitions
        event :next do

          # Addresses
          transitions from: :contact_postcode_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          transitions from: :contact_postcode_form,
                      to: :contact_address_lookup_form

          transitions from: :contact_address_lookup_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          # exemptions

          #   from edit_exemptions_form:
          #     return to main edit form if there are no exemption changes:
          transitions from: :edit_exemptions_form,
                      to: :front_office_edit_form,
                      if: :no_exemptions_deregistered?

          #     otherwise confirm exemption removal:
          transitions from: :edit_exemptions_form,
                      to: :confirm_edit_exemptions_form

          #   from confirm_edit_exemptions_form:
          #     to edit exemptions declaration page if exemption changes are confirmed AND all exemptions deregistered
          transitions from: :confirm_edit_exemptions_form,
                      to: :edit_exemptions_declaration_form,
                      if: :full_deregistration_confirmed?

          #     return to main edit page if exemption changes are confirmed
          transitions from: :confirm_edit_exemptions_form,
                      to: :front_office_edit_form,
                      if: :exemption_edits_confirmed?

          #     otherwise back to the edit exemptions page
          transitions from: :confirm_edit_exemptions_form,
                      to: :edit_exemptions_form

          #   from edit_exemptions_declaration_form:
          #     to registration complete only if all exemptions are being deregistered
          transitions from: :edit_exemptions_declaration_form,
                      to: :deregistration_complete_full_form,
                      if: :all_exemptions_deregistered?

          #     otherwise back to the main edit form
          transitions from: :edit_exemptions_declaration_form,
                      to: :front_office_edit_form

          # Completing the edit process
          transitions from: :front_office_edit_form,
                      to: :front_office_edit_declaration_form

          transitions from: :front_office_edit_declaration_form,
                      to: :front_office_edit_complete_no_changes_form,
                      if: :no_changes?

          transitions from: :front_office_edit_declaration_form,
                      to: :front_office_edit_complete_form

          # Everything else should always return to the main edit page
          transitions from: %i[
            contact_name_form
            contact_phone_form
            contact_email_form
            confirm_edit_exemptions_form
            contact_postcode_form
            contact_address_lookup_form
            contact_address_manual_form
          ], to: :front_office_edit_form
        end

        event :skip_to_manual_address do
          transitions from: :contact_postcode_form,
                      to: :contact_address_manual_form

          transitions from: :contact_address_lookup_form,
                      to: :contact_address_manual_form
        end

      end

      # helpers

      def all_exemptions_deregistered?
        exemptions.empty?
      end

      def no_exemptions_deregistered?
        excluded_exemptions.empty?
      end

      def no_changes?
        !modified?
      end

      def exemption_edits_confirmed?
        temp_confirm_exemption_edits == true
      end

      def full_deregistration_confirmed?
        exemption_edits_confirmed? && all_exemptions_deregistered?
      end
    end

    private

    def skip_to_manual_address?
      address_finder_error
    end
  end
end
# rubocop:enable Metrics/ModuleLength
