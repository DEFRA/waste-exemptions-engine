# frozen_string_literal: true

RSpec.shared_examples "a final state" do |previous_state:, current_state:|
  context "when a TransientRegistration's state is #{current_state}" do
    subject(:transient_registration) { create(:transient_registration, workflow_state: current_state) }

    it "can only transition to #{previous_state}" do
      permitted_states = transient_registration.aasm.states(permitted: true).map(&:name)
      expect(permitted_states).to eq([previous_state])
    end

    it "is unable to transition when the 'next' event is issued" do
      expect { transient_registration.next }.to raise_error(AASM::InvalidTransition)
    end

    it "changes to #{previous_state} after the 'back' event" do
      expect(transient_registration).to transition_from(current_state).to(previous_state).on_event(:back)
    end
  end
end
