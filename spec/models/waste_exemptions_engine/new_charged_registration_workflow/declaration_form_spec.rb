# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      let(:registration) { create(:new_charged_registration, workflow_state: :declaration_form) }

      context "when skip_payment? is true (only no-charge band exemptions)" do
        before do
          allow(registration).to receive(:skip_payment?).and_return(true)
        end

        it "transitions to registration_complete_form" do
          expect(registration)
            .to transition_from(:declaration_form)
            .to(:registration_complete_form)
            .on_event(:next)
        end
      end

      context "when skip_payment? is false (chargeable exemptions)" do
        before do
          allow(registration).to receive(:skip_payment?).and_return(false)
        end

        it "transitions to payment_summary_form" do
          expect(registration)
            .to transition_from(:declaration_form)
            .to(:payment_summary_form)
            .on_event(:next)
        end
      end
    end
  end
end
