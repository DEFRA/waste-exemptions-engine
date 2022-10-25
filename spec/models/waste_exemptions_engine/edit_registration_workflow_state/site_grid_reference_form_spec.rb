# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditRegistration do
    describe "#workflow_state" do
      previous_and_next_state = :edit_form
      current_state = :site_grid_reference_form
      subject(:edit_registration) { create(:edit_registration, workflow_state: current_state) }

      context "when a WasteExemptionsEngine::EditRegistration's state is #{current_state}" do
        alt_state = :site_postcode_form

        it "can only transition to either #{previous_and_next_state} or #{alt_state}" do
          permitted_states = Helpers::WorkflowStates.permitted_states(edit_registration)
          expect(permitted_states).to match_array([previous_and_next_state, alt_state])
        end

        it "changes to #{previous_and_next_state} after the 'next' event" do
          expect(edit_registration.send(:skip_to_manual_address?)).to be(false)
          expect(edit_registration).to transition_from(current_state).to(previous_and_next_state).on_event(:next)
        end

        it "changes to #{alt_state} after the 'skip_to_address' event" do
          expect(edit_registration.send(:skip_to_manual_address?)).to be(false)
          expect(edit_registration)
            .to transition_from(current_state)
            .to(alt_state)
            .on_event(:skip_to_address)
        end
      end
    end
  end
end
