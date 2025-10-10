# frozen_string_literal: true

FactoryBot.define do
  factory :confirm_activity_exemptions_form, class: "WasteExemptionsEngine::ConfirmActivityExemptionsForm" do
    trait :charged do
      # no additional setup needed - factory already uses charged registration
    end

    initialize_with { new(create(:new_charged_registration, workflow_state: "confirm_activity_exemptions_form")) }
  end

  factory :new_charged_registration_flow_confirm_activity_exemptions_form,
          class: "WasteExemptionsEngine::ConfirmActivityExemptionsForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "confirm_activity_exemptions_form"))
    end
  end
end
