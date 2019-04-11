# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditedRegistration, type: :model do
    describe "#workflow_state" do
      previous_state = :edit_form
      current_state = :location_form
      subject(:edited_registration) { create(:edited_registration, workflow_state: current_state) }

      context "when a EditedRegistration's state is #{current_state}" do
        context "when none of the should register in location conditions are true" do
          next_state = :edit_form

          before(:each) { edited_registration.location = "england" }

          it "can only transition to #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(edited_registration)
            expect(permitted_states).to match_array([next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(edited_registration.send(:should_register_in_northern_ireland?)).to eq(false)
            expect(edited_registration.send(:should_register_in_scotland?)).to eq(false)
            expect(edited_registration.send(:should_register_in_wales?)).to eq(false)
            expect(edited_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when edited_registration.should_register_in_northern_ireland? is true" do
          next_state = :register_in_northern_ireland_form

          before(:each) { edited_registration.location = "northern_ireland" }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(edited_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(edited_registration.send(:should_register_in_northern_ireland?)).to eq(true)
            expect(edited_registration.send(:should_register_in_scotland?)).to eq(false)
            expect(edited_registration.send(:should_register_in_wales?)).to eq(false)
            expect(edited_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when edited_registration.should_register_in_scotland? is true" do
          next_state = :register_in_scotland_form

          before(:each) { edited_registration.location = "scotland" }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(edited_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(edited_registration.send(:should_register_in_northern_ireland?)).to eq(false)
            expect(edited_registration.send(:should_register_in_scotland?)).to eq(true)
            expect(edited_registration.send(:should_register_in_wales?)).to eq(false)
            expect(edited_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when edited_registration.should_register_in_wales? is true" do
          next_state = :register_in_wales_form

          before(:each) { edited_registration.location = "wales" }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(edited_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(edited_registration.send(:should_register_in_northern_ireland?)).to eq(false)
            expect(edited_registration.send(:should_register_in_scotland?)).to eq(false)
            expect(edited_registration.send(:should_register_in_wales?)).to eq(true)
            expect(edited_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        it "changes to #{previous_state} after the 'back' event" do
          expect(edited_registration).to transition_from(current_state).to(previous_state).on_event(:back)
        end
      end
    end
  end
end
