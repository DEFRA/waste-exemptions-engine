# frozen_string_literal: true

FactoryBot.define do
  factory :renew_without_changes_form, class: WasteExemptionsEngine::RenewWithoutChangesForm do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "renew_without_changes_form"))
    end
  end
end
