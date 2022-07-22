# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      current_state = :location_form
      subject(:renewing_registration) { create(:renewing_registration, workflow_state: current_state) }

      context "when a RenewingRegistration's state is #{current_state}" do
        context "when none of the should register in location conditions are true" do
          next_state = :exemptions_form

          before(:each) { renewing_registration.location = "england" }

          it "can only transition to #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
            expect(permitted_states).to match_array([next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when renewing_registration.should_register_in_northern_ireland? is true" do
          next_state = :register_in_northern_ireland_form

          before(:each) { renewing_registration.location = "northern_ireland" }

          it "can only transition to #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
            expect(permitted_states).to match_array([next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when renewing_registration.should_register_in_scotland? is true" do
          next_state = :register_in_scotland_form

          before(:each) { renewing_registration.location = "scotland" }

          it "can only transition to #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
            expect(permitted_states).to match_array([next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        context "when renewing_registration.should_register_in_wales? is true" do
          next_state = :register_in_wales_form

          before(:each) { renewing_registration.location = "wales" }

          it "can only transition to #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
            expect(permitted_states).to match_array([next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end
      end
    end
  end
end
