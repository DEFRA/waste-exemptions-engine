# frozen_string_literal: true

FactoryBot.define do
  factory :is_a_farmer_form, class: "WasteExemptionsEngine::IsAFarmerForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "is_a_farmer_form"))
    end
  end

  factory :check_your_answers_edit_is_a_farmer_form, class: "WasteExemptionsEngine::IsAFarmerForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "is_a_farmer_form", is_a_farmer: true,
                                    temp_check_your_answers_flow: true))
    end
  end

  factory :renewal_start_edit_is_a_farmer_form, class: "WasteExemptionsEngine::IsAFarmerForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "is_a_farmer_form", is_a_farmer: true,
                                         temp_check_your_answers_flow: true))
    end
  end
end
