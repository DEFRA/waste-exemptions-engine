# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      current_state = :business_type_form
      subject(:new_registration) { create(:new_charged_registration, workflow_state: current_state) }

      context "when a NewChargedRegistration's state is #{current_state}" do
        context "when charity_in_front_office? is true" do
          next_state = :charity_register_free_form

          before do
            new_registration.business_type = TransientRegistration::BUSINESS_TYPES[:charity]
            allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
          end

          it "can only transition to #{next_state}" do
            permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
            expect(permitted_states).to contain_exactly(next_state)
          end

          it "changes to #{next_state} after the 'next' event" do
            aggregate_failures do
              expect(new_registration.send(:charity_in_front_office?)).to be(true)
              expect(new_registration).to transition_from(current_state).to(next_state).on_event(:next)
            end
          end
        end
      end
    end
  end
end
