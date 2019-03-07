# frozen_string_literal: true

module Helpers
  module WorkflowStates
    def self.can_navigate_flexibly_to_state?(state)
      previous_state = previous_state(WasteExemptionsEngine::TransientRegistration.new(workflow_state: state))
      state_can_navigate_flexibly?(previous_state) && state_can_navigate_flexibly?(state)
    end

    def self.state_can_navigate_flexibly?(state)
      form_class = WasteExemptionsEngine.const_get(state.to_s.camelize)
      form_class.can_navigate_flexibly?
    end

    def self.previous_state(transient_registration)
      # We need to find the resulting workflow state if the `back` event was triggered from the
      # current_state. Once we have the workflow state that preceded the one for the form being
      # tested, we can use this to test that a redirection takes place when the state is
      # insufficient for the requested page.
      state_machine = transient_registration.aasm
      permitted_events = state_machine.events(permitted: true)
      back_event = permitted_events.select { |e| e.name == :back }.first
      all_back_transitions = back_event.transitions_from_state(state_machine.current_state)
      allowed_back_transitions = all_back_transitions.select { |t| t.allowed?(transient_registration) }
      allowed_back_transitions.first.to
    end
  end
end
