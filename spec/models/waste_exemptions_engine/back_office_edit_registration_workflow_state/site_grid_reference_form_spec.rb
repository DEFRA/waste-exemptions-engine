# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BackOfficeEditRegistration do
    describe "#workflow_state" do
      subject(:back_office_edit_registration) do
        create(:back_office_edit_registration).tap do |registration|
          registration.update(workflow_state: :site_grid_reference_form)
        end
      end

      let(:current_state) { :site_grid_reference_form }
      let(:next_state) { :back_office_edit_form }

      it "has the correct current state" do
        expect(back_office_edit_registration.workflow_state).to eq(current_state.to_s)
      end

      it "allows the 'next' event" do
        expect(back_office_edit_registration).to allow_event(:next)
      end

      it "transitions to :back_office_edit_form on 'next' event" do
        expect(back_office_edit_registration).to transition_from(current_state).to(next_state).on_event(:next)
      end

      it "allows the 'skip_to_address' event" do
        expect(back_office_edit_registration).to allow_event(:skip_to_address)
      end

      it "transitions to :site_postcode_form on 'skip_to_address' event" do
        expect(back_office_edit_registration).to transition_from(current_state).to(:site_postcode_form).on_event(:skip_to_address)
      end

      it "cannot transition to any other state" do
        other_states = back_office_edit_registration.aasm.states.map(&:name) - [current_state, next_state, :site_postcode_form]
        aggregate_failures do
          other_states.each do |state|
            expect(back_office_edit_registration).not_to allow_transition_to(state)
          end
        end
      end
    end
  end
end
