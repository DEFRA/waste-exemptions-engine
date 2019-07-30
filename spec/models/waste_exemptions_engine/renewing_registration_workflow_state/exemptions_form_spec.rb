# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :location_form,
                      current_state: :exemptions_form,
                      next_state: :applicant_name_form,
                      factory: :renewing_registration
    end
  end
end
