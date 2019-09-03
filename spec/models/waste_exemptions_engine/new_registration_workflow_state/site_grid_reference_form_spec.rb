# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      previous_state = :is_a_farmer_form
      current_state = :site_grid_reference_form
      subject(:new_registration) { create(:new_registration, workflow_state: current_state) }

      context "when a NewRegistration's state is #{current_state}" do
        context "when new_registration.skip_to_manual_address? is false" do
          next_state = :check_your_answers_form
          alt_state = :site_postcode_form

          it "can only transition to either #{previous_state}, #{next_state}, or #{alt_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
            expect(permitted_states).to match_array([previous_state, next_state, alt_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(new_registration.send(:skip_to_manual_address?)).to eq(false)
            expect(new_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end

          it "changes to #{alt_state} after the 'skip_to_address' event" do
            expect(new_registration.send(:skip_to_manual_address?)).to eq(false)
            expect(new_registration)
              .to transition_from(current_state)
              .to(alt_state)
              .on_event(:skip_to_address)
          end
        end

        context "when new_registration.skip_to_manual_address? is true" do
          next_state = :site_postcode_form

          before(:each) { new_registration.address_finder_error = true }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(new_registration.send(:skip_to_manual_address?)).to eq(true)
            expect(new_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        it "changes to #{previous_state} after the 'back' event" do
          expect(new_registration).to transition_from(current_state).to(previous_state).on_event(:back)
        end
      end
    end
  end
end
