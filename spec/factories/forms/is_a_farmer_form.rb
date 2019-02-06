# frozen_string_literal: true

FactoryBot.define do
  factory :is_a_farmer_form, class: WasteExemptionsEngine::IsAFarmerForm do
    initialize_with { new(create(:transient_registration, workflow_state: "is_a_farmer_form")) }
  end
end
