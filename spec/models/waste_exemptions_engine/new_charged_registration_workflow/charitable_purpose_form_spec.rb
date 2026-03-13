# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_charged_registration,
               workflow_state: :charitable_purpose_form)
      end

      context "when charitable_purpose is true" do
        before { new_registration.charitable_purpose = true }

        it "transitions to charitable_purpose_declaration_form" do
          expect(new_registration)
            .to transition_from(:charitable_purpose_form)
            .to(:charitable_purpose_declaration_form)
            .on_event(:next)
        end
      end

      context "when charitable_purpose is false" do
        before { new_registration.charitable_purpose = false }

        it "transitions to exemptions_summary_form" do
          expect(new_registration)
            .to transition_from(:charitable_purpose_form)
            .to(:exemptions_summary_form)
            .on_event(:next)
        end
      end

      context "when in check your answers flow" do
        before do
          new_registration.temp_check_your_answers_flow = true
        end

        it "transitions to exemptions_summary_form" do
          expect(new_registration)
            .to transition_from(:charitable_purpose_form)
            .to(:exemptions_summary_form)
            .on_event(:next)
        end
      end
    end
  end
end
