# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      current_state = :registration_complete_form
      subject(:transient_registration) { create(:transient_registration, workflow_state: current_state) }

      context "when a TransientRegistration's state is #{current_state}" do
        it "can not transition to any states" do
          permitted_states = Helpers::WorkflowStates.permitted_states(transient_registration)
          expect(permitted_states).to be_empty
        end
      end
    end
  end
end
