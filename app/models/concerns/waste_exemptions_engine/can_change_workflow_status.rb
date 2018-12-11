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
        state :start_form, initial: true

        state :location_form
        state :register_in_northern_ireland_form
        state :register_in_scotland_form
        state :register_in_wales_form

        state :applicant_name_form
        state :applicant_phone_form
        state :applicant_email_form

        # Transitions
        event :next do
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

          transitions from: :applicant_name_form,
                      to: :applicant_phone_form

          transitions from: :applicant_phone_form,
                      to: :applicant_email_form
        end

        event :back do
          # Location

          transitions from: :location_form,
                      to: :start_form

          transitions from: :register_in_northern_ireland_form,
                      to: :location_form

          transitions from: :register_in_scotland_form,
                      to: :location_form

          transitions from: :register_in_wales_form,
                      to: :location_form

          # End location

          transitions from: :applicant_name_form,
                      to: :location_form

          transitions from: :applicant_phone_form,
                      to: :applicant_name_form

          transitions from: :applicant_email_form,
                      to: :applicant_phone_form
        end
      end
    end
    # rubocop:enable Metrics/BlockLength

    private

    def should_register_in_northern_ireland?
      location == "northern_ireland"
    end

    def should_register_in_scotland?
      location == "scotland"
    end

    def should_register_in_wales?
      location == "wales"
    end
  end
end
