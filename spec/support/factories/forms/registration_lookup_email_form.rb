# frozen_string_literal: true

FactoryBot.define do
  factory :registration_lookup_email_form, class: "WasteExemptionsEngine::RegistrationLookupEmailForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "registration_lookup_email_form"))
    end
  end
end
