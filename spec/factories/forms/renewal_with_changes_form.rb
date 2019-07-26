# frozen_string_literal: true

FactoryBot.define do
  factory :renew_with_changes_form, class: WasteExemptionsEngine::RenewWithChangesForm do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "renew_with_changes_form"))
    end
  end
end
