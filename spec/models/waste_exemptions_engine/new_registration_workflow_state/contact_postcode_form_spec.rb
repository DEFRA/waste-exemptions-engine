# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a postcode transition",
                      address_type: "contact",
                      factory: :new_registration
    end
  end
end
