# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      let(:current_state) { :is_multisite_registration_form }
      let(:new_registration) do
        create(:new_charged_registration,
               workflow_state: current_state,
               is_multisite_registration: is_multisite_registration)
      end

      context "when multisite feature is enabled" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
        end

        context "when is_multisite_registration is true" do
          let(:is_multisite_registration) { true }

          it "transitions to :multisite_site_grid_reference_form" do
            expect(new_registration)
              .to transition_from(current_state)
              .to(:multisite_site_grid_reference_form)
              .on_event(:next)
          end
        end

        context "when is_multisite_registration is false" do
          let(:is_multisite_registration) { false }

          context "when not in check your answers flow" do
            it "transitions to :exemptions_summary_form" do
              expect(new_registration)
                .to transition_from(current_state)
                .to(:exemptions_summary_form)
                .on_event(:next)
            end
          end

          context "when in check your answers flow" do
            before do
              new_registration.temp_check_your_answers_flow = true
            end

            it "transitions to :check_your_answers_form" do
              expect(new_registration)
                .to transition_from(current_state)
                .to(:check_your_answers_form)
                .on_event(:next)
            end
          end
        end
      end

      context "when multisite feature is disabled" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(false)
        end

        context "when is_multisite_registration is true" do
          let(:is_multisite_registration) { true }

          context "when not in check your answers flow" do
            it "transitions to :exemptions_summary_form" do
              expect(new_registration)
                .to transition_from(current_state)
                .to(:exemptions_summary_form)
                .on_event(:next)
            end
          end

          context "when in check your answers flow" do
            before do
              new_registration.temp_check_your_answers_flow = true
            end

            it "transitions to :check_your_answers_form" do
              expect(new_registration)
                .to transition_from(current_state)
                .to(:check_your_answers_form)
                .on_event(:next)
            end
          end
        end

        context "when is_multisite_registration is false" do
          let(:is_multisite_registration) { false }

          context "when not in check your answers flow" do
            it "transitions to :exemptions_summary_form" do
              expect(new_registration)
                .to transition_from(current_state)
                .to(:exemptions_summary_form)
                .on_event(:next)
            end
          end

          context "when in check your answers flow" do
            before do
              new_registration.temp_check_your_answers_flow = true
            end

            it "transitions to :check_your_answers_form" do
              expect(new_registration)
                .to transition_from(current_state)
                .to(:check_your_answers_form)
                .on_event(:next)
            end
          end
        end
      end
    end
  end
end
