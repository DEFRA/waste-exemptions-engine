# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    describe "#workflow_state" do
      subject(:renewing_registration) { create(:renewing_registration, workflow_state: :renewal_start_form) }

      let(:expected_available_states) do
        %i[
          exemptions_form
          applicant_name_form
          applicant_phone_form
          applicant_email_form
          confirm_renewal_form
          contact_name_form
          contact_phone_form
          contact_email_form
          contact_position_form
          contact_postcode_form
          on_a_farm_form
          is_a_farmer_form
          operator_postcode_form
        ]
      end

      it "can transition only to the designated states" do
        permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)

        expect(permitted_states).to match_array(expected_available_states)
      end

      it "changes to :confirm_renewal_form after the 'next' event" do
        expect(renewing_registration).to transition_from(:renewal_start_form).to(:confirm_renewal_form).on_event(:next)
      end
    end
  end
end
