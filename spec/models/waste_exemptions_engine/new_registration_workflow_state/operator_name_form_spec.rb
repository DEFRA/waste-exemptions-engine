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

        context "when neither new_registration.partnership? nor " \
        "new_registration.skip_registration_number? are true" do
          previous_state = :registration_number_form

          [TransientRegistration::BUSINESS_TYPES[:limited_company],
           TransientRegistration::BUSINESS_TYPES[:limited_liability_partnership]].each do |business_type|
            before(:each) { new_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to either #{previous_state} or #{next_state}" do
                permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
                expect(permitted_states).to match_array([previous_state, next_state])
              end

              it "changes to #{previous_state} after the 'back' event" do
                expect(new_registration.send(:partnership?)).to eq(false)
                expect(new_registration.send(:skip_registration_number?)).to eq(false)
                expect(new_registration).to transition_from(current_state).to(previous_state).on_event(:back)
              end
            end
          end
        end

        context "when new_registration.partnership? is true" do
          previous_state = :main_people_form

          [TransientRegistration::BUSINESS_TYPES[:partnership]].each do |business_type|
            before(:each) { new_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to either #{previous_state} or #{next_state}" do
                permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
                expect(permitted_states).to match_array([previous_state, next_state])
              end

              it "changes to #{previous_state} after the 'back' event" do
                expect(new_registration.send(:partnership?)).to eq(true)
                expect(new_registration.send(:skip_registration_number?)).to eq(true)
                expect(new_registration).to transition_from(current_state).to(previous_state).on_event(:back)
              end
            end
          end
        end

        context "when new_registration.skip_registration_number? is true" do
          previous_state = :business_type_form

          [TransientRegistration::BUSINESS_TYPES[:charity],
           TransientRegistration::BUSINESS_TYPES[:local_authority],
           TransientRegistration::BUSINESS_TYPES[:sole_trader]].each do |business_type|
            before(:each) { new_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to either #{previous_state} or #{next_state}" do
                permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
                expect(permitted_states).to match_array([previous_state, next_state])
              end

              it "changes to #{previous_state} after the 'back' event" do
                expect(new_registration.send(:partnership?)).to eq(false)
                expect(new_registration.send(:skip_registration_number?)).to eq(true)
                expect(new_registration).to transition_from(current_state).to(previous_state).on_event(:back)
              end
            end
          end
        end
      end
    end
  end
end
