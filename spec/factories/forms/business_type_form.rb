# frozen_string_literal: true

FactoryBot.define do
  factory :business_type_form, class: WasteExemptionsEngine::BusinessTypeForm do
    initialize_with do
      new(create(:transient_registration, workflow_state: "business_type_form"))
    end
  end
end
