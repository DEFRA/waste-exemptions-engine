# frozen_string_literal: true

module WasteExemptionsEngine
  module CanChangeWorkflowStatus
    extend ActiveSupport::Concern

    # We believe in the case of the different states and transitions for the
    # exemption journey, its better to see them all in one place. However this
    # does mean the block legnth breaks rubocops rules hence the exception.
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
        state :registration_number_form
        state :operator_name_form

        # Contact details
        state :contact_name_form

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
                      to: :operator_name_form,
                      if: :skip_registration_number?

          transitions from: :business_type_form,
                      to: :registration_number_form

          transitions from: :registration_number_form,
                      to: :operator_name_form

          transitions from: :operator_name_form,
                      to: :contact_name_form
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
          transitions from: :registration_number_form,
                      to: :business_type_form

          transitions from: :operator_name_form,
                      to: :business_type_form,
                      if: :skip_registration_number?

          transitions from: :operator_name_form,
                      to: :registration_number_form

          transitions from: :contact_name_form,
                      to: :operator_name_form
        end
      end
    end
    # rubocop:enable Metrics/BlockLength

    private

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
  end
end
