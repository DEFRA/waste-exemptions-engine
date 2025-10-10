# frozen_string_literal: true

FactoryBot.define do
  factory :is_multisite_registration_form, class: "WasteExemptionsEngine::IsMultisiteRegistrationForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "is_multisite_registration_form"))
    end

    trait :charged do
      # no additional setup needed - factory already uses charged registration
    end
  end

  factory :check_your_answers_edit_is_multisite_registration_form,
          class: "WasteExemptionsEngine::IsMultisiteRegistrationForm" do
    initialize_with do
      new(create(:new_charged_registration,
                 workflow_state: "is_multisite_registration_form",
                 is_multisite_registration: true,
                 temp_check_your_answers_flow: true))
    end
  end
end
