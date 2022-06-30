# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      subject(:renewing_registration) { create(:renewing_registration, workflow_state: :renewal_start_form) }

      context "when the renewing registration is a company or LLP" do
        previous_state = :check_registered_name_and_address_form

        context "when subject.should_renew_without_changes? is false" do
          next_state = :renew_with_changes_form
          before(:each) { subject.temp_renew_without_changes = false }

          it "can only transition to either #{previous_state} or #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(subject)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to :renew_with_changes_form after the 'next' event" do
            expect(subject).to transition_from(:renewal_start_form).to(:renew_with_changes_form).on_event(:next)
          end
        end

        context "when subject.should_renew_without_changes? is true" do
          next_state = :renew_without_changes_form
          before(:each) { subject.temp_renew_without_changes = true }

          it "can only transition to :renew_without_changes_form" do
            permitted_states = Helpers::WorkflowStates.permitted_states(subject)
            expect(permitted_states).to match_array([previous_state, next_state])
          end

          it "changes to :renew_without_changes_form after the 'next' event" do
            expect(subject).to transition_from(:renewal_start_form).to(:renew_without_changes_form).on_event(:next)
          end
        end
      end

      context "when the renewing registration isn't a company or LLP" do
        before do
          allow_any_instance_of(CanUseRenewingRegistrationWorkflow).to receive(:skip_registration_number?).and_return(true)
        end

        it "is unable to transition when the 'back' event is issued" do
          expect { renewing_registration.back }.to raise_error(AASM::InvalidTransition)
        end
      end
    end
  end
end
