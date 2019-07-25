# frozen_string_literal: true

module Helpers
  module WorkflowStates
    def self.permitted_states(transient_registration)
      transient_registration.aasm.states(permitted: true).map(&:name)
    end

    def self.can_navigate_flexibly_to_state?(state)
      previous_state = previous_state(WasteExemptionsEngine::NewRegistration.new(workflow_state: state))

      previous_state && state_can_navigate_flexibly?(previous_state) && state_can_navigate_flexibly?(state)
    end

    def self.state_can_navigate_flexibly?(state)
      form_class = WasteExemptionsEngine.const_get(state.to_s.camelize)
      form_class.can_navigate_flexibly?
    end

    def self.previous_state(transient_registration)
      state_machine = transient_registration.class.aasm

      state_machine.events.each do |event|
        next unless event.name == :back

        previous_state_transition = event.transitions.find do |transition|
          transition.allowed?(transient_registration) && transition.from == transient_registration.aasm.current_state
        end

        return previous_state_transition.to if previous_state_transition
      end


      unless transient_registration.registration_complete_form?
        raise(StandardError, "No previous state found for #{transient_registration.aasm.current_state}")
      end
    end
  end
end
