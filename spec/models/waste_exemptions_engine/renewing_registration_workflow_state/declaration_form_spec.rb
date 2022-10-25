# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      current_state: :declaration_form,
                      next_state: :renewal_complete_form,
                      factory: :renewing_registration_without_changes

      it_behaves_like "a simple bidirectional transition",
                      current_state: :declaration_form,
                      next_state: :renewal_complete_form,
                      factory: :renewing_registration
    end
  end
end
