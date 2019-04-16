# frozen_string_literal: true

FactoryBot.define do
  factory :contact_address_lookup_form, class: WasteExemptionsEngine::ContactAddressLookupForm do
    initialize_with do
      new(
        create(:new_registration,
               workflow_state: "contact_address_lookup_form",
               temp_contact_postcode: "BS1 5AH")
      )
    end
  end
end
