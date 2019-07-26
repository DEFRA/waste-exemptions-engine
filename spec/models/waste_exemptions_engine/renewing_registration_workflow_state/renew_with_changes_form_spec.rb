# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :renewal_start_form,
                      current_state: :renew_with_changes_form,
                      next_state: :renewal_complete_form,
                      factory: :renewing_registration
    end
  end
end
