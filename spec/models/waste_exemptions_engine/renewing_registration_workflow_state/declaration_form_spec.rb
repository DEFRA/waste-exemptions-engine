# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :renew_without_changes_form,
                      current_state: :declaration_form,
                      next_state: :renewal_complete_form,
                      factory: :renewing_registration_without_changes

      it_behaves_like "a simple bidirectional transition",
                      previous_state: :check_your_answers_form,
                      current_state: :declaration_form,
                      next_state: :renewal_complete_form,
                      factory: :renewing_registration
    end
  end
end
