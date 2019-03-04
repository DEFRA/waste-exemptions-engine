# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      next_state = :contact_position_form
      current_state = :contact_name_form
      let(:operator_address) { build(:transient_address, :operator_address) }
      subject(:transient_registration) do
        create(:transient_registration, workflow_state: current_state, addresses: [operator_address])
      end

      context "when a TransientRegistration's state is #{current_state}" do
        it "changes to #{next_state} after the 'next' event" do
          expect(transient_registration).to transition_from(current_state).to(next_state).on_event(:next)
        end

        context "when transient_registration.operator_address_was_manually_entered? is true" do
          previous_state = :operator_address_manual_form

          before(:each) { transient_registration.operator_address.manual! }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = transient_registration.aasm.states(permitted: true).map(&:name)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{previous_state} after the 'back' event" do
            expect(transient_registration.send(:operator_address_was_manually_entered?)).to eq(true)
            expect(transient_registration).to transition_from(current_state).to(previous_state).on_event(:back)
          end
        end

        context "when transient_registration.operator_address_was_manually_entered? is false" do
          previous_state = :operator_address_lookup_form

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = transient_registration.aasm.states(permitted: true).map(&:name)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{previous_state} after the 'back' event" do
            expect(transient_registration.send(:operator_address_was_manually_entered?)).to eq(false)
            expect(transient_registration).to transition_from(current_state).to(previous_state).on_event(:back)
          end
        end
      end
    end
  end
end
