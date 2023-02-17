# frozen_string_literal: true

FactoryBot.define do
  factory :deregistration_complete_full_form, class: "WasteExemptionsEngine::DeregistrationCompleteFullForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "deregistration_complete_full_form"))
    end
  end
end
