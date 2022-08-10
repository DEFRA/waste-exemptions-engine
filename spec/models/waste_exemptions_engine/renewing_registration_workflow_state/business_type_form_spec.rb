# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      current_state = :business_type_form
      subject(:renewing_registration) { create(:renewing_registration, workflow_state: current_state) }

      context "when a Renwing Registration's state is #{current_state}" do
        context "when changing business type" do
          next_state = :cannot_renew_type_change_form

          [TransientRegistration::BUSINESS_TYPES[:limited_liability_partnership],
           TransientRegistration::BUSINESS_TYPES[:partnership],
           TransientRegistration::BUSINESS_TYPES[:charity],
           TransientRegistration::BUSINESS_TYPES[:local_authority],
           TransientRegistration::BUSINESS_TYPES[:sole_trader]].each do |business_type|
            before(:each) { renewing_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "changes to #{next_state} after the 'next' event" do
                expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
              end
            end
          end
        end

        context "when keeping business type" do
          next_state = :operator_postcode_form

          [TransientRegistration::BUSINESS_TYPES[:limited_company]].each do |business_type|
            before(:each) { renewing_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to #{next_state}" do
                permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
                expect(permitted_states).to match_array([next_state])
              end

              it "changes to #{next_state} after the 'next' event" do
                expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
              end
            end
          end
        end
      end
    end
  end
end
