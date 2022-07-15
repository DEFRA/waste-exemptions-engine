# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      next_state = :operator_postcode_form
      current_state = :operator_name_form
      subject(:new_registration) { create(:new_registration, workflow_state: current_state) }

      context "when a NewRegistration's state is #{current_state}" do
        it "changes to #{next_state} after the 'next' event" do
          expect(new_registration).to transition_from(current_state).to(next_state).on_event(:next)
        end

        context "when new_registration.partnership? is true" do
          [TransientRegistration::BUSINESS_TYPES[:partnership]].each do |business_type|
            before(:each) { new_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to #{next_state}" do
                permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
                expect(permitted_states).to match_array([next_state])
              end
            end
          end
        end

        context "when new_registration.skip_registration_number? is true" do
          [TransientRegistration::BUSINESS_TYPES[:charity],
           TransientRegistration::BUSINESS_TYPES[:local_authority],
           TransientRegistration::BUSINESS_TYPES[:sole_trader]].each do |business_type|
            before(:each) { new_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to #{next_state}" do
                permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
                expect(permitted_states).to match_array([next_state])
              end
            end
          end
        end
      end
    end
  end
end
