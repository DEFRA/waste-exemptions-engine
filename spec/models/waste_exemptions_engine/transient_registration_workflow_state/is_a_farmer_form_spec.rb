# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :on_a_farm_form,
                      current_state: :is_a_farmer_form,
                      next_state: :site_grid_reference_form
    end
  end
end
