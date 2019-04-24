# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditRegistration, type: :model do
    describe "#workflow_state" do
      current_state = :edit_form
      subject(:edit_registration) { create(:edit_registration, workflow_state: current_state) }

      editable_form_states = %i[
        location_form
        applicant_name_form
        applicant_phone_form
        applicant_email_form
        main_people_form
        registration_number_form
        operator_name_form
        operator_postcode_form
        contact_name_form
        contact_phone_form
        contact_email_form
        contact_postcode_form
        on_a_farm_form
        is_a_farmer_form
        site_grid_reference_form
      ]

      transitionable_states = editable_form_states + [:declaration_form]

      context "when a WasteExemptionsEngine::EditRegistration's state is #{current_state}" do
        it "can only transition to the allowed states" do
          permitted_states = Helpers::WorkflowStates.permitted_states(edit_registration)
          expect(permitted_states).to match_array(transitionable_states)
        end

        editable_form_states.each do |expected_state|
          state_without_form_suffix = expected_state.to_s.remove("_form")
          event = "edit_#{state_without_form_suffix}".to_sym

          it "changes to #{expected_state} after the '#{event}' event" do
            expect(subject).to transition_from(current_state).to(expected_state).on_event(event)
          end
        end
      end
    end
  end
end
