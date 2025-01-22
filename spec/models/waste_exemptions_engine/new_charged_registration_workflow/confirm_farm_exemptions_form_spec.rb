# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_charged_registration,
               workflow_state: :confirm_farm_exemptions_form,
               temp_confirm_exemptions: temp_confirm_exemptions,
               temp_exemptions: temp_exemption_ids)
      end

      let(:temp_exemption_ids) do
        create_list(:exemption, 3)
        Exemption.limit(3).map(&:id)
      end

      context "when temp_confirm_exemptions is true" do
        let(:temp_confirm_exemptions) { true }

        it "transitions to :site_grid_reference_form" do
          expect(new_registration)
            .to transition_from(:confirm_farm_exemptions_form)
            .to(:site_grid_reference_form)
            .on_event(:next)
        end
      end

      context "when temp_confirm_exemptions is false" do
        let(:temp_confirm_exemptions) { false }

        it "transitions to :farm_exemptions_form" do
          expect(new_registration)
            .to transition_from(:confirm_farm_exemptions_form)
            .to(:farm_exemptions_form)
            .on_event(:next)
        end
      end
    end
  end
end
