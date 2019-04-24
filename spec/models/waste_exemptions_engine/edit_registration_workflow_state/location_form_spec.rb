# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditRegistration, type: :model do
    describe "#workflow_state" do
      previous_state = :edit_form
      current_state = :location_form
      subject(:edit_registration) { create(:edit_registration, workflow_state: current_state) }

      context "when a WasteExemptionsEngine::EditRegistration's state is #{current_state}" do
        context "when none of the should register in location conditions are true" do
          next_state = :edit_form

          before(:each) { edit_registration.location = "england" }

          it "can only transition to #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(edit_registration)
            expect(permitted_states).to match_array([next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(edit_registration.send(:should_register_in_northern_ireland?)).to eq(false)
            expect(edit_registration.send(:should_register_in_scotland?)).to eq(false)
            expect(edit_registration.send(:should_register_in_wales?)).to eq(false)
            expect(edit_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when edit_registration.should_register_in_northern_ireland? is true" do
          next_state = :register_in_northern_ireland_form

          before(:each) { edit_registration.location = "northern_ireland" }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(edit_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(edit_registration.send(:should_register_in_northern_ireland?)).to eq(true)
            expect(edit_registration.send(:should_register_in_scotland?)).to eq(false)
            expect(edit_registration.send(:should_register_in_wales?)).to eq(false)
            expect(edit_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when edit_registration.should_register_in_scotland? is true" do
          next_state = :register_in_scotland_form

          before(:each) { edit_registration.location = "scotland" }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(edit_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(edit_registration.send(:should_register_in_northern_ireland?)).to eq(false)
            expect(edit_registration.send(:should_register_in_scotland?)).to eq(true)
            expect(edit_registration.send(:should_register_in_wales?)).to eq(false)
            expect(edit_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when edit_registration.should_register_in_wales? is true" do
          next_state = :register_in_wales_form

          before(:each) { edit_registration.location = "wales" }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(edit_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(edit_registration.send(:should_register_in_northern_ireland?)).to eq(false)
            expect(edit_registration.send(:should_register_in_scotland?)).to eq(false)
            expect(edit_registration.send(:should_register_in_wales?)).to eq(true)
            expect(edit_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        it "changes to #{previous_state} after the 'back' event" do
          expect(edit_registration).to transition_from(current_state).to(previous_state).on_event(:back)
        end
      end
    end
  end
end
