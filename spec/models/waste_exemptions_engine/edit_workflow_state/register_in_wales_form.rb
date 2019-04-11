# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a final state",
                      previous_state: :location_form,
                      current_state: :register_in_wales_form,
                      factory: :edited_registration
    end
  end
end
