# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      current_state: :is_a_farmer_form,
                      next_state: :site_grid_reference_form,
                      factory: :new_registration
    end
  end
end
