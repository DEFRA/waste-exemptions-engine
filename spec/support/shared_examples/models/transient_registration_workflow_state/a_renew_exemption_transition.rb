# frozen_string_literal: true

RSpec.shared_examples "a renew exemption transition" do |factory:|
  describe "#workflow_state" do
    current_state = :renew_exemptions_form

    subject { create(factory, workflow_state: current_state) }

    context "when subject.any_exemptions_selected? is true" do
      next_state = :applicant_name_form

      it "transitions from #{current_state} to #{next_state}" do
        permitted_states = Helpers::WorkflowStates.permitted_states(subject)

        aggregate_failures do
          expect(subject.send(:any_exemptions_selected?)).to be(true)
          expect(permitted_states).to match_array([next_state])
        end
      end

      it "changes to #{next_state} after the 'next' event" do
        aggregate_failures do
          expect(subject.send(:any_exemptions_selected?)).to be(true)
          expect(subject).to transition_from(current_state).to(next_state).on_event(:next)
        end
      end
    end

    context "when subject.any_exemptions_selected? is false" do
      next_state = :renew_no_exemptions_form

      before { subject.exemptions = [] }

      it "transitions from #{current_state} to #{next_state}" do
        permitted_states = Helpers::WorkflowStates.permitted_states(subject)

        aggregate_failures do
          expect(subject.send(:any_exemptions_selected?)).to be(false)
          expect(permitted_states).to match_array([next_state])
        end
      end

      it "changes to #{next_state} after the 'next' event" do
        aggregate_failures do
          expect(subject.send(:any_exemptions_selected?)).to be(false)
          expect(subject).to transition_from(current_state).to(next_state).on_event(:next)
        end
      end
    end
  end
end
