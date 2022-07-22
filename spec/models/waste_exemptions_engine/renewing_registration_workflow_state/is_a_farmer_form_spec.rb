# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      current_state: :is_a_farmer_form,
                      next_state: :site_grid_reference_form,
                      factory: :renewing_registration

      it_behaves_like "a simple bidirectional transition",
                      current_state: :is_a_farmer_form,
                      next_state: :site_postcode_form,
                      factory: :renewing_registration_with_manual_site_address
    end
  end
end
