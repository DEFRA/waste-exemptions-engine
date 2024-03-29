# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BackOfficeEditRegistration do
    describe "#workflow_state" do
      current_state = :back_office_edit_form
      subject(:edit_registration) { create(:back_office_edit_registration, workflow_state: current_state) }

      editable_form_states = %i[
        applicant_name_form
        applicant_phone_form
        applicant_email_form
        main_people_form
        registration_number_form
        operator_name_form
        operator_postcode_form
        contact_name_form
        contact_position_form
        contact_phone_form
        contact_email_form
        contact_postcode_form
        on_a_farm_form
        is_a_farmer_form
        site_grid_reference_form
      ]

      transitionable_states = editable_form_states + %i[declaration_form confirm_back_office_edit_cancelled_form]

      context "when a WasteExemptionsEngine::BackOfficeEditRegistration's state is #{current_state}" do
        it "can only transition to the allowed states" do
          permitted_states = Helpers::WorkflowStates.permitted_states(edit_registration)
          expect(permitted_states).to match_array(transitionable_states)
        end

        editable_form_states.each do |expected_state|
          state_without_form_suffix = expected_state.to_s.remove("_form")
          event = :"edit_#{state_without_form_suffix}"

          it "changes to #{expected_state} after the '#{event}' event" do
            expect(edit_registration).to transition_from(current_state).to(expected_state).on_event(event)
          end
        end

        it "changes to declaration_form after the 'next' event" do
          expected_state = :declaration_form
          event = :next
          expect(edit_registration).to transition_from(current_state).to(expected_state).on_event(event)
        end

        it "changes to confirm_back_office_edit_cancelled after the 'cancel_edit' event" do
          expected_state = :confirm_back_office_edit_cancelled_form
          event = :cancel_edit
          expect(edit_registration).to transition_from(current_state).to(expected_state).on_event(event)
        end
      end
    end
  end
end
