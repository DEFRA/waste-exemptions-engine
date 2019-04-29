# frozen_string_literal: true

RSpec.shared_examples "a final state" do |previous_state:, current_state:, factory:|
  context "when a subject's state is #{current_state}" do
    subject(:subject) { create(factory, workflow_state: current_state) }

    it "can only transition to #{previous_state}" do
      permitted_states = Helpers::WorkflowStates.permitted_states(subject)
      expect(permitted_states).to eq([previous_state])
    end

    it "is unable to transition when the 'next' event is issued" do
      expect { subject.next }.to raise_error(AASM::InvalidTransition)
    end

    it "changes to #{previous_state} after the 'back' event" do
      expect(subject).to transition_from(current_state).to(previous_state).on_event(:back)
    end
  end
end
