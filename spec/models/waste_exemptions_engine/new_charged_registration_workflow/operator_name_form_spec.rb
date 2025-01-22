# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      let(:current_state) { :operator_name_form }

      subject(:new_registration) { create(:new_charged_registration, workflow_state: current_state) }

      context "when the registration is not farm_affiliated" do
        before { allow(new_registration).to receive(:farm_affiliated?).and_return(false) }

        it "changes to waste_activities_form after the 'next' event" do
          expect(new_registration).to transition_from(current_state).to(:waste_activities_form).on_event(:next)
        end
      end

      context "when the registration is farm_affiliated" do
        before { allow(new_registration).to receive(:farm_affiliated?).and_return(true) }

        it "changes to farm_exemptions_form after the 'next' event" do
          expect(new_registration).to transition_from(current_state).to(:farm_exemptions_form).on_event(:next)
        end
      end
    end
  end
end
