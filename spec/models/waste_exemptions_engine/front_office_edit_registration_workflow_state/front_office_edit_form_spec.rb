# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FrontOfficeEditRegistration do
    describe "#workflow_state" do
      current_state = :front_office_edit_form
      subject(:edit_registration) { create(:front_office_edit_registration, workflow_state: current_state) }

      editable_form_states = %i[
        edit_exemptions_form
        contact_name_form
        contact_phone_form
        contact_email_form
      ]

      transitionable_states = editable_form_states + %i[front_office_edit_declaration_form]

      context "when a WasteExemptionsEngine::FrontOfficeEditRegistration's state is #{current_state}" do
        it "can only transition to the allowed states" do
          permitted_states = Helpers::WorkflowStates.permitted_states(edit_registration)
          expect(permitted_states).to match_array(transitionable_states)
        end

        editable_form_states.each do |expected_state|
          state_without_form_suffix = expected_state.to_s.remove("_form")
          event_prefix = "edit_" unless expected_state.start_with?("edit_")
          event = "#{event_prefix}#{state_without_form_suffix}".to_sym

          it "changes to #{expected_state} after the '#{event}' event" do
            expect(edit_registration).to transition_from(current_state).to(expected_state).on_event(event)
          end
        end

        it "changes to declaration_form after the 'next' event" do
          expect(edit_registration).to transition_from(current_state).to(:front_office_edit_declaration_form).on_event(:next)
        end
      end
    end
  end
end
