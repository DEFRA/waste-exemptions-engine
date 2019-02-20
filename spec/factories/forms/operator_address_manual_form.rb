# frozen_string_literal: true

FactoryBot.define do
  factory :operator_address_manual_form, class: WasteExemptionsEngine::OperatorAddressManualForm do
    initialize_with do
      new(create(:transient_registration, workflow_state: "operator_address_manual_form"))
    end
  end
end
