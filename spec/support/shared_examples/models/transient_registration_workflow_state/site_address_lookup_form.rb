# frozen_string_literal: true

RSpec.shared_examples "site_address_lookup_form" do |factory, next_state|
  current_state = :site_address_lookup_form
  subject(:transient_registration) { create(factory, workflow_state: current_state) }

  it "can only transition to #{next_state}" do
    permitted_states = Helpers::WorkflowStates.permitted_states(transient_registration)
    expect(permitted_states).to contain_exactly(next_state)
  end

  it "changes to #{next_state} after the 'next' event" do
    expect(transient_registration).to transition_from(current_state).to(next_state).on_event(:next)
  end
end
