# frozen_string_literal: true

FactoryBot.define do
  factory :operator_postcode_form, class: WasteExemptionsEngine::OperatorPostcodeForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "operator_postcode_form"))
    end
  end

  factory :edit_operator_postcode_form, class: WasteExemptionsEngine::OperatorPostcodeForm do
    initialize_with do
      new(create(:edit_registration, workflow_state: "operator_postcode_form"))
    end
  end

  factory :renew_operator_postcode_form, class: WasteExemptionsEngine::OperatorPostcodeForm do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "operator_postcode_form"))
    end
  end
end
