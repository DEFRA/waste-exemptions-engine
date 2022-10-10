# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      let(:site_address) { build(:transient_address, :site_address) }

      it_behaves_like "a simple bidirectional transition",
                      current_state: :check_your_answers_form,
                      next_state: :declaration_form,
                      factory: :renewing_registration

      it_behaves_like "a simple bidirectional transition",
                      current_state: :check_your_answers_form,
                      next_state: :declaration_form,
                      factory: :renewing_registration_with_manual_site_address

      next_state = :declaration_form
      current_state = :check_your_answers_form

      subject(:renewing_registration) do
        create(:renewing_registration, workflow_state: current_state, addresses: [site_address])
      end

      context "when renewing_registration.site_address_was_manually_entered? is true" do
        before { renewing_registration.site_address.manual! }

        it "can only transition to #{next_state}" do
          permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
          expect(permitted_states).to match_array([next_state])
        end
      end

      context "when renewing_registration.site_address_was_entered? is true" do
        before { renewing_registration.site_address.lookup! }

        it "can only transition to #{next_state}" do
          permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
          expect(permitted_states).to match_array([next_state])
        end
      end
    end
  end
end
