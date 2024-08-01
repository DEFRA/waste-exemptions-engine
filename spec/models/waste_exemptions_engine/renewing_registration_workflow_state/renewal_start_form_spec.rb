# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    describe "#workflow_state" do
      subject(:renewing_registration) { create(:renewing_registration, workflow_state: :renewal_start_form) }

      context "when subject.should_renew_without_changes? is true" do
        next_state = :renew_without_changes_form

        it "can only transition to :renew_without_changes_form" do
          permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
          expect(permitted_states).to contain_exactly(next_state)
        end

        it "changes to :renew_without_changes_form after the 'next' event" do
          expect(renewing_registration).to transition_from(:renewal_start_form).to(:renew_without_changes_form).on_event(:next)
        end
      end
    end
  end
end
