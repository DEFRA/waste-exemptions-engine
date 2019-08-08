# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :site_grid_reference_form,
                      current_state: :check_your_answers_form,
                      next_state: :declaration_form,
                      factory: :renewing_registration

      it_behaves_like "a simple bidirectional transition",
                      previous_state: :site_address_manual_form,
                      current_state: :check_your_answers_form,
                      next_state: :declaration_form,
                      factory: :renewing_registration_with_manual_site_address

      next_state = :declaration_form
      current_state = :check_your_answers_form
      let(:site_address) { build(:transient_address, :site_address) }
      subject(:renewing_registration) do
        create(:renewing_registration, workflow_state: current_state, addresses: [site_address])
      end

      context "when renewing_registration.site_address_was_manually_entered? is true" do
        previous_state = :site_address_manual_form

        before(:each) { renewing_registration.site_address.manual! }

        it "can only transition to either #{previous_state} or #{next_state}" do
          permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
          expect(permitted_states).to match_array([previous_state, next_state])
        end

        it "changes to #{previous_state} after the 'back' event" do
          expect(renewing_registration.send(:site_address_was_manually_entered?)).to eq(true)
          expect(renewing_registration.send(:site_address_was_entered?)).to eq(false)
          expect(renewing_registration).to transition_from(current_state).to(previous_state).on_event(:back)
        end
      end

      context "when renewing_registration.site_address_was_entered? is true" do
        previous_state = :site_address_lookup_form

        before(:each) { renewing_registration.site_address.lookup! }

        it "can only transition to either #{previous_state} or #{next_state}" do
          permitted_states = Helpers::WorkflowStates.permitted_states(renewing_registration)
          expect(permitted_states).to match_array([previous_state, next_state])
        end

        it "changes to #{previous_state} after the 'back' event" do
          expect(renewing_registration.send(:site_address_was_manually_entered?)).to eq(false)
          expect(renewing_registration.send(:site_address_was_entered?)).to eq(true)
          expect(renewing_registration).to transition_from(current_state).to(previous_state).on_event(:back)
        end
      end
    end
  end
end
