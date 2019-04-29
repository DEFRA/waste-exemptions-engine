# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "an address lookup transition",
                      next_state_if_not_skipping_to_manual: :exemptions_form,
                      address_type: "site",
                      factory: :new_registration
    end
  end
end
