# frozen_string_literal: true

FactoryBot.define do
  factory :on_a_farm_form, class: WasteExemptionsEngine::OnAFarmForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "on_a_farm_form"))
    end
  end
end
