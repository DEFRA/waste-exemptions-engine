# frozen_string_literal: true

RSpec.shared_examples "site_grid_reference_form" do
  current_state = :site_grid_reference_form
  subject(:renewing_registration) { create(:renewing_registration, workflow_state: current_state) }

  context "when a RenewingRegistration's state is #{current_state}" do
    next_state = :check_your_answers_form

    it "can only transition to #{next_state}" do
      permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
      expect(permitted_states).to match_array([next_state])
    end

    it "changes to #{next_state} after the 'next' event" do
      expect(renewing_registration.send(:skip_to_manual_address?)).to be(false)
      expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
    end
  end
end
