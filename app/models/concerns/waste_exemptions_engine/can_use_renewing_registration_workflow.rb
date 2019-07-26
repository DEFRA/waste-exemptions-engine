# frozen_string_literal: true

module WasteExemptionsEngine
  module CanUseRenewingRegistrationWorkflow
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :workflow_state do
        # States / forms

        state :renewal_start_form, initial: true
        state :renew_with_changes_form
        state :renewal_complete_form

        # Transitions
        event :next do
          transitions from: :renewal_start_form,
                      to: :renew_with_changes_form

          transitions from: :renew_with_changes_form,
                      to: :renewal_complete_form
        end

        event :back do
          transitions from: :renew_with_changes_form,
                      to: :renewal_start_form
        end
      end
    end
  end
end
