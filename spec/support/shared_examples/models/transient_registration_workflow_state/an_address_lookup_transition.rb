# frozen_string_literal: true

RSpec.shared_examples "an address lookup transition" do |next_state_if_not_skipping_to_manual:, address_type:, factory:|
  describe "#workflow_state" do
    current_state = "#{address_type}_address_lookup_form".to_sym
    subject { create(factory, workflow_state: current_state) }

    context "when subject.skip_to_manual_address? is false" do
      next_state = next_state_if_not_skipping_to_manual
      alt_state = "#{address_type}_address_manual_form".to_sym

      it "can only transition to #{next_state} or #{alt_state}" do
        permitted_states = Helpers::WorkflowStates.permitted_states(subject)
        expect(permitted_states).to contain_exactly(next_state, alt_state)
      end

      it "changes to #{next_state} after the 'next' event" do
        expect(subject.send(:skip_to_manual_address?)).to be(false)
        expect(subject).to transition_from(current_state).to(next_state).on_event(:next)
      end

      it "changes to #{alt_state} after the 'skip_to_manual_address' event" do
        expect(subject.send(:skip_to_manual_address?)).to be(false)
        expect(subject)
          .to transition_from(current_state)
          .to(alt_state)
          .on_event(:skip_to_manual_address)
      end
    end

    context "when subject.skip_to_manual_address? is true" do
      next_state = "#{address_type}_address_manual_form".to_sym

      before { subject.address_finder_error = true }

      it "can only transition to #{next_state}" do
        permitted_states = Helpers::WorkflowStates.permitted_states(subject)
        expect(permitted_states).to contain_exactly(next_state)
      end

      it "changes to #{next_state} after the 'next' event" do
        expect(subject.send(:skip_to_manual_address?)).to be(true)
        expect(subject).to transition_from(current_state).to(next_state).on_event(:next)
      end

      it "changes to #{next_state} after the 'skip_to_manual_address' event" do
        expect(subject.send(:skip_to_manual_address?)).to be(true)
        expect(subject)
          .to transition_from(current_state)
          .to(next_state)
          .on_event(:skip_to_manual_address)
      end
    end
  end
end
