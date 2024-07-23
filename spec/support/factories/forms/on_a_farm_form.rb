# frozen_string_literal: true

FactoryBot.define do
  factory :on_a_farm_form, class: "WasteExemptionsEngine::OnAFarmForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "on_a_farm_form"))
    end
  end

  factory :check_your_answers_edit_on_a_farm_form, class: "WasteExemptionsEngine::OnAFarmForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "on_a_farm_form", on_a_farm: true,
                                    temp_check_your_answers_flow: true))
    end
  end

  factory :renewal_start_edit_on_a_farm_form, class: "WasteExemptionsEngine::OnAFarmForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "on_a_farm_form", on_a_farm: true,
                                         temp_check_your_answers_flow: true))
    end
  end
end
