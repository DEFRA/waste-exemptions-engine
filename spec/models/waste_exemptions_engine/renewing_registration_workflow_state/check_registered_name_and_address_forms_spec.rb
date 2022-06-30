# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      current_state = :check_registered_name_and_address_form
      subject(:renewing_registration) { create(:renewing_registration, workflow_state: current_state) }

      context "when subject.temp_use_registered_company_details is false" do
        before(:each) { subject.temp_use_registered_company_details = false }

        it "can only transition to :incorrect_company_form" do
          permitted_states = Helpers::WorkflowStates.permitted_states(subject)
          expect(permitted_states).to match_array([:incorrect_company_form])
        end

        it "changes to :incorrect_company_form after the 'next' event" do
          expect(subject).to transition_from(:check_registered_name_and_address_form).to(:incorrect_company_form).on_event(:next)
        end
      end

      context "when subject.temp_use_registered_company_details is true" do
        before(:each) { subject.temp_use_registered_company_details = true }

        it "can only transition to :renewal_start_form" do
          permitted_states = Helpers::WorkflowStates.permitted_states(subject)
          expect(permitted_states).to match_array([:renewal_start_form])
        end

        it "changes to :renewal_start_form after the 'next' event" do
          expect(subject).to transition_from(:check_registered_name_and_address_form).to(:renewal_start_form).on_event(:next)
        end
      end

      it "is unable to tranisition when the 'back' event is issued" do
        expect { renewing_registration.back }.to raise_error(AASM::InvalidTransition)
      end
    end
  end
end
