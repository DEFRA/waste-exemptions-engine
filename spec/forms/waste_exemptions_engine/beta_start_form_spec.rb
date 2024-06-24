# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BetaStartForm, type: :model do
    subject(:form) { build(:beta_start_form) }

    describe "#submit" do
      context "when the form is valid" do
        it "creates the transient registration with the correct type" do
          form.submit({})
          aggregate_failures do
            expect(form.transient_registration.type).to eq("WasteExemptionsEngine::NewChargedRegistration")
            expect(form.transient_registration.workflow_state).to eq("beta_start_form")
          end
        end
      end
    end
  end
end
