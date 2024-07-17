# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple progressing transition",
                      current_state: :exemptions_form,
                      next_state: :applicant_name_form,
                      factory: :new_registration
    end
  end
end
