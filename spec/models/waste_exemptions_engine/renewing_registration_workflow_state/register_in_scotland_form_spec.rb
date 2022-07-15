# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a final state",
                      current_state: :register_in_scotland_form,
                      factory: :renewing_registration
    end
  end
end
