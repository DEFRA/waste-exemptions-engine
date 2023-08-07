# frozen_string_literal: true

FactoryBot.define do
  factory :registration_lookup_complete_form, class: "WasteExemptionsEngine::RegistrationLookupCompleteForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "registration_lookup_complete_form"))
    end
  end
end
