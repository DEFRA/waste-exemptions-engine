# frozen_string_literal: true

FactoryBot.define do
  factory :operator_address_lookup_form, class: WasteExemptionsEngine::OperatorAddressLookupForm do
    initialize_with do
      new(
        create(:new_registration,
               workflow_state: "operator_address_lookup_form",
               temp_operator_postcode: "BS1 5AH")
      )
    end
  end
end
