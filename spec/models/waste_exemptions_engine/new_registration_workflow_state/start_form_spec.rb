# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      current_state = :start_form
      subject(:new_registration) { create(:new_registration, workflow_state: current_state) }

      context "when a NewRegistration's state is #{current_state}" do
        context "when new_registration.should_contact_the_agency? is true" do
          before { new_registration.start_option = "edit" }

          it "can only transition to :capture_reference_form" do
            permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
            expect(permitted_states).to eq([:capture_reference_form])
          end

          it "changes to :capture_reference_form after the 'next' event" do
            expect(new_registration.send(:should_edit?)).to be(true)
            expect(new_registration).to transition_from(current_state).to(:capture_reference_form).on_event(:next)
          end
        end

        context "when new_registration.should_edit? is false" do
          it "can only transition to :location_form" do
            permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
            expect(permitted_states).to eq([:location_form])
          end

          it "changes to :location_form after the 'next' event" do
            expect(new_registration.send(:should_edit?)).to be(false)
            expect(new_registration).to transition_from(current_state).to(:location_form).on_event(:next)
          end
        end
      end
    end
  end
end
