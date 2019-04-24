# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      previous_state = :start_form
      current_state = :location_form
      subject(:new_registration) { create(:new_registration, workflow_state: current_state) }

      context "when a NewRegistration's state is #{current_state}" do
        context "when none of the should register in location conditions are true" do
          next_state = :applicant_name_form

          before(:each) { new_registration.location = "england" }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(new_registration.send(:should_register_in_northern_ireland?)).to eq(false)
            expect(new_registration.send(:should_register_in_scotland?)).to eq(false)
            expect(new_registration.send(:should_register_in_wales?)).to eq(false)
            expect(new_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when new_registration.should_register_in_northern_ireland? is true" do
          next_state = :register_in_northern_ireland_form

          before(:each) { new_registration.location = "northern_ireland" }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(new_registration.send(:should_register_in_northern_ireland?)).to eq(true)
            expect(new_registration.send(:should_register_in_scotland?)).to eq(false)
            expect(new_registration.send(:should_register_in_wales?)).to eq(false)
            expect(new_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when new_registration.should_register_in_scotland? is true" do
          next_state = :register_in_scotland_form

          before(:each) { new_registration.location = "scotland" }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(new_registration.send(:should_register_in_northern_ireland?)).to eq(false)
            expect(new_registration.send(:should_register_in_scotland?)).to eq(true)
            expect(new_registration.send(:should_register_in_wales?)).to eq(false)
            expect(new_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when new_registration.should_register_in_wales? is true" do
          next_state = :register_in_wales_form

          before(:each) { new_registration.location = "wales" }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(new_registration.send(:should_register_in_northern_ireland?)).to eq(false)
            expect(new_registration.send(:should_register_in_scotland?)).to eq(false)
            expect(new_registration.send(:should_register_in_wales?)).to eq(true)
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
