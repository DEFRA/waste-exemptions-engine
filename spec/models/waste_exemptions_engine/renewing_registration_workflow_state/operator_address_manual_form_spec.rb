# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      current_state: :operator_address_manual_form,
                      next_state: :contact_name_form,
                      factory: :renewing_registration
    end
  end
end
