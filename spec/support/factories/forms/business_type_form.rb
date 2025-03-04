# frozen_string_literal: true

FactoryBot.define do
  factory :business_type_form, class: "WasteExemptionsEngine::BusinessTypeForm" do
    trait :charged do
      # currently business_type_form is available for charged registrations only,
      # so factory gets initialised with charged registration by default
      # no need to do anything here.
    end

    initialize_with do
      new(create(:new_registration, workflow_state: "business_type_form"))
    end
  end

  factory :edit_business_type_form, class: "WasteExemptionsEngine::BusinessTypeForm" do
    initialize_with do
      new(create(:back_office_edit_registration, workflow_state: "business_type_form"))
    end
  end

  factory :renew_business_type_form, class: "WasteExemptionsEngine::BusinessTypeForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "business_type_form"))
    end
  end
end
