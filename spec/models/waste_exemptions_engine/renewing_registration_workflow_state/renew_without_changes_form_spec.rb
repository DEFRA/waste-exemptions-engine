# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      current_state: :renew_without_changes_form,
                      next_state: :declaration_form,
                      factory: :renewing_registration
    end
  end
end
