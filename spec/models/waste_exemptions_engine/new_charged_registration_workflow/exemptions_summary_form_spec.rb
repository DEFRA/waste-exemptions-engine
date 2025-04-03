# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_charged_registration,
               workflow_state: :exemptions_summary_form)
      end

      context "when not in check_your_answers_flow" do
        before do
          allow(new_registration).to receive(:check_your_answers_flow?).and_return(false)
        end

        it "transitions to site_grid_reference_form" do
          expect(new_registration)
            .to transition_from(:exemptions_summary_form)
            .to(:site_grid_reference_form)
            .on_event(:next)
        end
      end

      context "when in check_your_answers_flow" do
        before do
          allow(new_registration).to receive(:check_your_answers_flow?).and_return(true)
        end

        it "transitions to declaration_form" do
          expect(new_registration)
            .to transition_from(:exemptions_summary_form)
            .to(:declaration_form)
            .on_event(:next)
        end
      end
    end
  end
end
