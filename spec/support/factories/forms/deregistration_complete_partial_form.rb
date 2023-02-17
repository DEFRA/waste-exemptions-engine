# frozen_string_literal: true

FactoryBot.define do
  factory :deregistration_complete_partial_form, class: "WasteExemptionsEngine::DeregistrationCompletePartialForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "deregistration_complete_partial_form"))
    end
  end
end
