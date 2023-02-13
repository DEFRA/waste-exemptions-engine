# frozen_string_literal: true

FactoryBot.define do
  factory :renew_no_exemptions_form, class: "WasteExemptionsEngine::RenewNoExemptionsForm" do
    initialize_with { new(create(:renewing_registration, workflow_state: "renew_no_exemptions_form")) }
  end
end
