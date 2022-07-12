# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      next_state = :operator_address_lookup_form
      current_state = :operator_postcode_form
      subject(:renewing_registration) { create(:renewing_registration, workflow_state: current_state) }

      context "when a RenewingRegistration's state is #{current_state}" do
        context "when renewing_registrations business type is a company or llp" do
          previous_state = :business_type_form

          [TransientRegistration::BUSINESS_TYPES[:limited_liability_partnership],
           TransientRegistration::BUSINESS_TYPES[:limited_company]].each do |business_type|
            before(:each) { renewing_registration.business_type = business_type }

            it "can transition to either #{previous_state} or #{next_state}" do
              expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
            end

            it "changes to #{previous_state} after the 'back' event" do
              expect(renewing_registration).to transition_from(current_state).to(previous_state).on_event(:back)
            end
          end
        end

        context "when renewing_registration business type is not a company or llp" do
          previous_state = :operator_name_form

          [TransientRegistration::BUSINESS_TYPES[:charity],
           TransientRegistration::BUSINESS_TYPES[:local_authority],
           TransientRegistration::BUSINESS_TYPES[:partnership],
           TransientRegistration::BUSINESS_TYPES[:sole_trader]].each do |business_type|
            before(:each) { renewing_registration.business_type = business_type }

            it "can only transition to either #{previous_state} or #{next_state}" do
              expect(renewing_registration).to transition_from(current_state).to(next_state).on_event(:next)
            end

            it "changes to #{previous_state} after the 'back' event" do
              expect(renewing_registration).to transition_from(current_state).to(previous_state).on_event(:back)
            end
          end
        end
      end
    end
  end
end
