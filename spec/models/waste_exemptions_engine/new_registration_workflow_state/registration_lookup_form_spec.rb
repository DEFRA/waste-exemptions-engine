# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      current_state = :registration_lookup_form
      next_state = :registration_lookup_email_form
      let(:new_registration) do
        create(:new_registration,
               workflow_state: current_state,
               reference: reference)
      end
      let(:reference) { nil }

      context "when a NewRegistration's state is #{current_state}" do
        let(:reference) { Faker::Internet.email }

        it "can only transition to :registration_lookup_email_form" do
          permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
          expect(permitted_states).to contain_exactly(next_state)
        end

        it "transitions to :registration_lookup_email_form" do
          expect(new_registration)
            .to transition_from(current_state)
            .to(next_state)
            .on_event(:next)
        end
      end
    end
  end
end
