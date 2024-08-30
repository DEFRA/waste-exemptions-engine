# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do

    RSpec.shared_examples "a renewal start form return transition" do |current_state:|
      context "when a subject's state is #{current_state}" do
        subject(:renewing_registration) { create(:renewing_registration, workflow_state: current_state) }

        let(:next_state) { :renewal_start_form }

        before { renewing_registration.temp_check_your_answers_flow = true }

        it "can only transition to renewal_start_form" do
          permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
          expect(permitted_states).to contain_exactly(:renewal_start_form)
        end

        it "changes to renewal_start_form after the 'next' event" do
          expect(renewing_registration).to transition_from(current_state).to(:renewal_start_form).on_event(:next)
        end
      end
    end

    describe "#workflow_state" do
      it_behaves_like "a renewal start form return transition", current_state: :applicant_email_form
      it_behaves_like "a renewal start form return transition", current_state: :applicant_name_form
      it_behaves_like "a renewal start form return transition", current_state: :applicant_phone_form
      it_behaves_like "a renewal start form return transition", current_state: :contact_address_manual_form
      it_behaves_like "a renewal start form return transition", current_state: :contact_email_form
      it_behaves_like "a renewal start form return transition", current_state: :contact_name_form
      it_behaves_like "a renewal start form return transition", current_state: :contact_phone_form
      it_behaves_like "a renewal start form return transition", current_state: :contact_position_form
      it_behaves_like "a renewal start form return transition", current_state: :exemptions_form
      it_behaves_like "a renewal start form return transition", current_state: :is_a_farmer_form
      it_behaves_like "a renewal start form return transition", current_state: :on_a_farm_form
      it_behaves_like "a renewal start form return transition", current_state: :operator_address_manual_form
    end
  end
end
