# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple progressing transition",
                      current_state: :waste_activities_form,
                      next_state: :activity_exemptions_form,
                      factory: :new_charged_registration
    end
  end
end
