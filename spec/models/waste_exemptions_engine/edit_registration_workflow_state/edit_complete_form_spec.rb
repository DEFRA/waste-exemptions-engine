# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditRegistration, type: :model do
    describe "#workflow_state" do
      current_state = :edit_complete_form
      subject(:edit_registration) { create(:edit_registration, workflow_state: current_state) }

      context "when a WasteExemptionsEngine::EditRegistration's state is #{current_state}" do
        it "can not transition to any states" do
          permitted_states = Helpers::WorkflowStates.permitted_states(edit_registration)
          expect(permitted_states).to be_empty
        end
      end
    end
  end
end
