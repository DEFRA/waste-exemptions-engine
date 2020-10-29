# frozen_string_literal: true

FactoryBot.define do
  factory :registration_complete_form, class: WasteExemptionsEngine::RegistrationCompleteForm do
    initialize_with do
      new(create(:new_registration, :complete, workflow_state: "registration_complete_form"))
    end
  end
end
