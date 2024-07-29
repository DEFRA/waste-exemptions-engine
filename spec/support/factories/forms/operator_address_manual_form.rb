# frozen_string_literal: true

FactoryBot.define do
  factory :operator_address_manual_form, class: "WasteExemptionsEngine::OperatorAddressManualForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "operator_address_manual_form"))
    end
  end

  factory :check_your_answers_operator_address_manual_form, class: "WasteExemptionsEngine::OperatorAddressManualForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "operator_address_manual_form", temp_check_your_answers_flow: true))
    end
  end

  factory :renewal_start_operator_address_manual_form, class: "WasteExemptionsEngine::OperatorAddressManualForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "operator_address_manual_form",
                                         temp_check_your_answers_flow: true))
    end
  end
end
