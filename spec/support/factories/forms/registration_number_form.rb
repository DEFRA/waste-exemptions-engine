# frozen_string_literal: true

FactoryBot.define do
  factory :registration_number_form, class: "WasteExemptionsEngine::RegistrationNumberForm" do
    initialize_with { new(create(:new_registration, workflow_state: "registration_number_form")) }
  end
end
