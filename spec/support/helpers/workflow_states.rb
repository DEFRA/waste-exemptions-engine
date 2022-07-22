# frozen_string_literal: true

module Helpers
  module WorkflowStates
    def self.permitted_states(transient_registration)
      transient_registration.aasm.states(permitted: true).map(&:name)
    end

    def self.can_navigate_flexibly_to_state?(state)
      return false unless state_can_navigate_flexibly?(state)

      previous_state = previous_state(WasteExemptionsEngine::NewRegistration.new(workflow_state: state))

      previous_state && state_can_navigate_flexibly?(previous_state)
    end

    def self.state_can_navigate_flexibly?(state)
      form_class = WasteExemptionsEngine.const_get(state.to_s.camelize)
      form_class.can_navigate_flexibly?
    end

    # The purpose of this method is to find a valid previous state for a given transient registration's state.
    # In order to do that, we get the data of the state machine of the transient registration class, and we search for
    # the states which handle :next events by moving to the transient registration's current state.
    # We return the first result found as that is adequate to support the unit tests.
    def self.previous_state(transient_registration)
      state_machine = transient_registration.class.aasm

      state_machine.events.each do |event|
        next unless event.name == :next

        to_transitions = event.transitions.select { |t| t.to == transient_registration.aasm.current_state }
        transition = to_transitions.first

        return transition.from if transition.present?
      end

      # If no result is found, then there is something logically wrong. One reason might be that the current state is
      # the start of the user journey, or an inescapable end point.
      raise(StandardError, "No previous state found for #{transient_registration.aasm.current_state}")
    end
  end
end
