# frozen_string_literal: true

FactoryBot.define do
  factory :check_registered_name_and_address_form, class: "WasteExemptionsEngine::CheckRegisteredNameAndAddressForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "check_registered_name_and_address_form"))
    end
  end

  factory :renew_check_registered_name_and_address_form,
          class: "WasteExemptionsEngine::CheckRegisteredNameAndAddressForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "check_registered_name_and_address_form"))
    end
  end
end
