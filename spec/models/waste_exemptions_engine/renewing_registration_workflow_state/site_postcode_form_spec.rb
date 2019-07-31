# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a postcode transition",
                      previous_state: :site_grid_reference_form,
                      address_type: "site",
                      factory: :renewing_registration
    end
  end
end
