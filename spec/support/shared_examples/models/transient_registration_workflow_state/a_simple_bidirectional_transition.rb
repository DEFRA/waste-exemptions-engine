# frozen_string_literal: true

RSpec.shared_examples "a simple bidirectional transition" do |current_state:, next_state:, factory:|
  context "when a subject's state is #{current_state}" do
    subject { create(factory, workflow_state: current_state) }

    it "can only transition to #{next_state}" do
      permitted_states = Helpers::WorkflowStates.permitted_states(subject)
      expect(permitted_states).to contain_exactly(next_state)
    end

    it "changes to #{next_state} after the 'next' event" do
      expect(subject).to transition_from(current_state).to(next_state).on_event(:next)
    end
  end
end
