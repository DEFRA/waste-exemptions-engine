# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      next_state = :is_a_farmer_form
      current_state = :on_a_farm_form
      let(:contact_address) { build(:transient_address, :contact_address) }
      subject(:renewing_registration) do
        create(:renewing_registration, workflow_state: current_state, addresses: [contact_address])
      end

      context "when a RenewingRegistration's state is #{current_state}" do
        it "changes to #{next_state} after the 'next' event" do
          expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
        end

        context "when renewing_registration.contact_address_was_manually_entered? is true" do
          previous_state = :contact_address_manual_form

          before(:each) { renewing_registration.contact_address.manual! }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{previous_state} after the 'back' event" do
            expect(renewing_registration.send(:contact_address_was_manually_entered?)).to eq(true)
            expect(renewing_registration).to transition_from(current_state).to(previous_state).on_event(:back)
          end
        end

        context "when renewing_registration.contact_address_was_manually_entered? is false" do
          previous_state = :contact_address_lookup_form

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{previous_state} after the 'back' event" do
            expect(renewing_registration.send(:contact_address_was_manually_entered?)).to eq(false)
            expect(renewing_registration).to transition_from(current_state).to(previous_state).on_event(:back)
          end
        end
      end
    end
  end
end
