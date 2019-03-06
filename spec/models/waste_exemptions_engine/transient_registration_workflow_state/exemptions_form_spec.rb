# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      next_state = :check_your_answers_form
      current_state = :exemptions_form
      let(:site_address) { build(:transient_address, :site_address) }
      subject(:transient_registration) do
        create(:transient_registration, workflow_state: current_state, addresses: [site_address])
      end

      context "when a TransientRegistration's state is #{current_state}" do
        it "changes to #{next_state} after the 'next' event" do
          expect(transient_registration).to transition_from(current_state).to(next_state).on_event(:next)
        end

        context "when neither transient_registration.site_address_was_manually_entered? nor " \
        "transient_registration.site_address_was_entered? are true" do
          previous_state = :site_grid_reference_form

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(transient_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{previous_state} after the 'back' event" do
            expect(transient_registration.send(:site_address_was_manually_entered?)).to eq(false)
            expect(transient_registration.send(:site_address_was_entered?)).to eq(false)
            expect(transient_registration).to transition_from(current_state).to(previous_state).on_event(:back)
          end
        end

        context "when transient_registration.site_address_was_manually_entered? is true" do
          previous_state = :site_address_manual_form

          before(:each) { transient_registration.site_address.manual! }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(transient_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{previous_state} after the 'back' event" do
            expect(transient_registration.send(:site_address_was_manually_entered?)).to eq(true)
            expect(transient_registration.send(:site_address_was_entered?)).to eq(false)
            expect(transient_registration).to transition_from(current_state).to(previous_state).on_event(:back)
          end
        end

        context "when transient_registration.site_address_was_entered? is true" do
          previous_state = :site_address_lookup_form

          before(:each) { transient_registration.site_address.lookup! }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(transient_registration)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to #{previous_state} after the 'back' event" do
            expect(transient_registration.send(:site_address_was_manually_entered?)).to eq(false)
            expect(transient_registration.send(:site_address_was_entered?)).to eq(true)
            expect(transient_registration).to transition_from(current_state).to(previous_state).on_event(:back)
          end
        end
      end
    end
  end
end
