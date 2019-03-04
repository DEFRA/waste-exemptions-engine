# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :location_form,
                      current_state: :applicant_name_form,
                      next_state: :applicant_phone_form
    end
  end
end
