# frozen_string_literal: true

FactoryBot.define do
  factory :contact_phone_form, class: WasteExemptionsEngine::ContactPhoneForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_phone_form"))
    end
  end
end
