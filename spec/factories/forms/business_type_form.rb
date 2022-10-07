# frozen_string_literal: true

FactoryBot.define do
  factory :business_type_form, class: "WasteExemptionsEngine::BusinessTypeForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "business_type_form"))
    end
  end

  factory :edit_business_type_form, class: "WasteExemptionsEngine::BusinessTypeForm" do
    initialize_with do
      new(create(:edit_registration, workflow_state: "business_type_form"))
    end
  end

  factory :renew_business_type_form, class: "WasteExemptionsEngine::BusinessTypeForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "business_type_form"))
    end
  end
end
