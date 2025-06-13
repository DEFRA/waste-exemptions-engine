# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_charged_registration,
               workflow_state: :exemptions_summary_form)
      end

      it "transitions to site_grid_reference_form" do
        expect(new_registration)
          .to transition_from(:exemptions_summary_form)
          .to(:site_grid_reference_form)
          .on_event(:next)
      end

      context "when in check your answers flow" do
        before do
          new_registration.temp_check_your_answers_flow = true
        end

        it "transitions to check_your_answers_form" do
          expect(new_registration)
            .to transition_from(:exemptions_summary_form)
            .to(:check_your_answers_form)
            .on_event(:next)
        end
      end
    end
  end
end
