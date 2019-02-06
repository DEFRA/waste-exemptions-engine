# frozen_string_literal: true

FactoryBot.define do
  factory :on_a_farm_form, class: WasteExemptionsEngine::OnAFarmForm do
    initialize_with { new(create(:transient_registration, workflow_state: "on_a_farm_form")) }
  end
end
