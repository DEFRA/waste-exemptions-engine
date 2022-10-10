# frozen_string_literal: true

FactoryBot.define do
  factory :check_contact_phone_form, class: "WasteExemptionsEngine::CheckContactPhoneForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "check_contact_phone_form", applicant_phone: Faker::PhoneNumber.phone_number))
    end
  end
end
