# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      next_state = :operator_postcode_form
      current_state = :operator_name_form
      subject(:renewing_registration) { create(:renewing_registration, workflow_state: current_state) }

      context "when a RenewingRegistration's state is #{current_state}" do
        it "changes to #{next_state} after the 'next' event" do
          expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
        end

        context "when renewing_registration.partnership? is true" do
          previous_state = :main_people_form

          [TransientRegistration::BUSINESS_TYPES[:partnership]].each do |business_type|
            before(:each) { renewing_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to either #{previous_state} or #{next_state}" do
                permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
                expect(permitted_states).to match_array([previous_state, next_state])
              end

              it "changes to #{previous_state} after the 'back' event" do
                expect(renewing_registration.send(:partnership?)).to eq(true)
                expect(renewing_registration.send(:skip_registration_number?)).to eq(true)
                expect(renewing_registration).to transition_from(current_state).to(previous_state).on_event(:back)
              end
            end
          end
        end

        context "when renewing_registration.skip_registration_number? is true" do
          previous_state = :business_type_form

          [TransientRegistration::BUSINESS_TYPES[:charity],
           TransientRegistration::BUSINESS_TYPES[:local_authority],
           TransientRegistration::BUSINESS_TYPES[:sole_trader]].each do |business_type|
            before(:each) { renewing_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to either #{previous_state} or #{next_state}" do
                permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
                expect(permitted_states).to match_array([previous_state, next_state])
              end

              it "changes to #{previous_state} after the 'back' event" do
                expect(renewing_registration.send(:partnership?)).to eq(false)
                expect(renewing_registration.send(:skip_registration_number?)).to eq(true)
                expect(renewing_registration).to transition_from(current_state).to(previous_state).on_event(:back)
              end
            end
          end
        end
      end
    end
  end
end
