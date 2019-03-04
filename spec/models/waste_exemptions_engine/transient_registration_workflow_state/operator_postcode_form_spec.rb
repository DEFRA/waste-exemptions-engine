# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      previous_state = :operator_name_form
      current_state = :operator_postcode_form
      subject(:transient_registration) { create(:transient_registration, workflow_state: current_state) }

      context "when a TransientRegistration's state is #{current_state}" do
        context "when transient_registration.skip_to_manual_address? is false" do
          next_state = :operator_address_lookup_form
          alt_state = :operator_address_manual_form

          before(:each) { transient_registration.address_finder_error = false }

          it "can only transition to either #{previous_state},  #{next_state} #{alt_state}" do
            permitted_states = transient_registration.aasm.states(permitted: true).map(&:name)
            expect(permitted_states).to match_array([previous_state, next_state, alt_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(transient_registration.send(:skip_to_manual_address?)).to eq(false)
            expect(transient_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end

          it "changes to #{alt_state} after the 'skip_to_manual_address' event" do
            expect(transient_registration.send(:skip_to_manual_address?)).to eq(false)
            expect(transient_registration)
              .to transition_from(current_state)
              .to(alt_state)
              .on_event(:skip_to_manual_address)
          end
        end

        context "when transient_registration.skip_to_manual_address? is true" do
          next_state = :operator_address_manual_form

          before(:each) { transient_registration.address_finder_error = true }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = transient_registration.aasm.states(permitted: true).map(&:name)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{next_state} after the 'next' event" do
            expect(transient_registration.send(:skip_to_manual_address?)).to eq(true)
            expect(transient_registration).to transition_from(current_state).to(next_state).on_event(:next)
          end
        end

        it "changes to #{previous_state} after the 'back' event" do
          expect(transient_registration).to transition_from(current_state).to(previous_state).on_event(:back)
        end
      end
    end
  end
end
