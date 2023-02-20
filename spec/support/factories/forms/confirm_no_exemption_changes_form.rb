# frozen_string_literal: true

FactoryBot.define do
  factory :confirm_no_exemption_changes_form, class: "WasteExemptionsEngine::ConfirmNoExemptionChangesForm" do
    initialize_with { new(create(:renewing_registration, workflow_state: "confirm_no_exemption_changes_form")) }
  end
end
