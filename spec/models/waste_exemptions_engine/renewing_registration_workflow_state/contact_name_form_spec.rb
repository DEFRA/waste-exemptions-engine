# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    describe "#workflow_state" do
      next_state = :contact_position_form
      current_state = :contact_name_form
      let(:operator_address) { build(:transient_address, :operator_address) }

      subject(:renewing_registration) do
        create(:renewing_registration, workflow_state: current_state, addresses: [operator_address])
      end

      context "when a RenewingRegistration's state is #{current_state}" do
        it "changes to #{next_state} after the 'next' event" do
          expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
        end

        context "when renewing_registration.operator_address_was_manually_entered? is true" do
          before { renewing_registration.operator_address.manual! }

          it "can only transition to #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
            expect(permitted_states).to contain_exactly(next_state)
          end
        end

        context "when renewing_registration.operator_address_was_manually_entered? is false" do
          it "can only transition to #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
            expect(permitted_states).to contain_exactly(next_state)
          end
        end
      end
    end
  end
end
