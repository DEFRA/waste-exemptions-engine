# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_charged_registration,
               workflow_state: :confirm_farm_exemptions_form,
               temp_add_additional_non_bucket_exemptions: temp_add_additional_non_bucket_exemptions,
               temp_exemptions: temp_exemptions,
               temp_confirm_exemptions: temp_confirm_exemptions)
      end

      context "when proceeding with selected farm exemptions" do
        let(:temp_add_additional_non_bucket_exemptions) { false }
        let(:temp_confirm_exemptions) { true }

        context "when farm exemptions have been selected" do
          let(:temp_exemptions) { [create(:exemption).id] }

          it "transitions to is_multisite_registration_form" do
            expect(new_registration)
              .to transition_from(:confirm_farm_exemptions_form)
              .to(:is_multisite_registration_form)
              .on_event(:next)
          end
        end

        context "when no farm exemptions have been selected" do
          let(:temp_exemptions) { [] }

          context "when looking to add additional non-farm exemptions" do
            let(:temp_add_additional_non_bucket_exemptions) { true }

            it "transitions to waste_activities_form" do
              expect(new_registration)
                .to transition_from(:confirm_farm_exemptions_form)
                .to(:waste_activities_form)
                .on_event(:next)
            end
          end

          context "when not looking to add additional non-farm exemptions" do
            let(:temp_add_additional_non_bucket_exemptions) { false }

            it "transitions to no_farm_exemptions_selected_form" do
              expect(new_registration)
                .to transition_from(:confirm_farm_exemptions_form)
                .to(:no_farm_exemptions_selected_form)
                .on_event(:next)
            end
          end
        end
      end

      context "when adding additional non-farm exemptions" do
        let(:temp_add_additional_non_bucket_exemptions) { true }
        let(:temp_confirm_exemptions) { true }
        let(:temp_exemptions) { [create(:exemption).id] }

        it "transitions to waste_activities_form" do
          expect(new_registration)
            .to transition_from(:confirm_farm_exemptions_form)
            .to(:waste_activities_form)
            .on_event(:next)
        end
      end

      context "when in check your answers flow" do
        let(:temp_add_additional_non_bucket_exemptions) { false }
        let(:temp_confirm_exemptions) { true }
        let(:temp_exemptions) { [create(:exemption).id] }

        before do
          new_registration.temp_check_your_answers_flow = true
        end

        it "transitions to exemptions_summary_form" do
          expect(new_registration)
            .to transition_from(:confirm_farm_exemptions_form)
            .to(:exemptions_summary_form)
            .on_event(:next)
        end
      end
    end
  end
end
