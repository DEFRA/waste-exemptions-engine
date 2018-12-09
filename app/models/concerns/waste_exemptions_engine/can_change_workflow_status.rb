# frozen_string_literal: true

module WasteExemptionsEngine
  module CanChangeWorkflowStatus
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :workflow_state do
        # States / forms
        state :start_form, initial: true

        # Transitions
        event :next do
          transitions from: :start_form,
                      to: :location_form
        end
      end
    end
  end
end
