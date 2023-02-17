# frozen_string_literal: true

FactoryBot.define do
  factory :deregistration_complete_no_change_form, class: "WasteExemptionsEngine::DeregistrationCompleteNoChangeForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "deregistration_complete_no_change_form"))
    end
  end
end
