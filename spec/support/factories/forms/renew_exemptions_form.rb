# frozen_string_literal: true

FactoryBot.define do
  factory :renew_exemptions_form, class: "WasteExemptionsEngine::RenewExemptionsForm" do
    initialize_with { new(create(:renewing_registration, workflow_state: "renew_exemptions_form")) }
  end
end
