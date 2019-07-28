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

    # The purpose of this method is to dynamically find a valid previous state for a given transient registration's state.
    # In order to do that, we get the data of the state machine of the transient registration class, and we search in all
    # back event which handles moving from a transient registration's current state to a previous valid state.
    def self.previous_state(transient_registration)
      state_machine = transient_registration.class.aasm

      state_machine.events.each do |event|
        # We are only interested in :back events. Those are the only that define a valid previous state for a
        # transient registration
        next unless event.name == :back

        previous_state_transition = event.transitions.find do |transition|
          # Once we find a valid transition, we have to make sure such transition can be run in the current object.
          # Some transitions have extra `:if:` and `:unless:` rules that define on which object they are valid to run,
          # the `#allowed?` method will run those checks on the give object for the given transaction
          transition.allowed?(transient_registration) && transition.from == transient_registration.aasm.current_state
        end

        # We exit the method and return the first valid result
        return previous_state_transition.to if previous_state_transition
      end

      # If no result is found, then there is something logically wrong. One reason might be that the current state is not a
      # flexibly navigatable one.
      raise(StandardError, "No previous state found for #{transient_registration.aasm.current_state}")
    end
  end
end
