# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      let(:site_address) { build(:transient_address, :site_address) }

      it_behaves_like "a simple progressing transition",
                      current_state: :check_your_answers_form,
                      next_state: :declaration_form,
                      factory: :new_charged_registration

      next_state = :declaration_form
      current_state = :check_your_answers_form

      subject(:new_registration) do
        create(:new_charged_registration, workflow_state: current_state, addresses: [site_address])
      end

      context "when new_registration.site_address_was_manually_entered? is true" do
        before { new_registration.site_address.manual! }

        it "can only transition to #{next_state}" do
          permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
          expect(permitted_states).to contain_exactly(next_state)
        end
      end

      context "when new_registration.site_address_was_entered? is true" do
        before { new_registration.site_address.lookup! }

        it "can only transition to #{next_state}" do
          permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
          expect(permitted_states).to contain_exactly(next_state)
        end
      end

      context "when the registration is farm_affiliated" do
        before { allow(new_registration).to receive(:farm_affiliated?).and_return(true) }

        it "may transition to farm_exemptions_form after the 'next' event" do
          permitted_states = Helpers::WorkflowStates.permitted_states(new_registration)
          expect(permitted_states).to include(:farm_exemptions_form)
        end
      end
    end
  end
end
