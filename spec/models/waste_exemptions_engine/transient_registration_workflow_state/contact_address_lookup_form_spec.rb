# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "an address lookup transition",
                      next_state_without_skipping_to_manual: :on_a_farm_form,
                      address_type: "contact",
                      factory: :transient_registration
    end
  end
end
