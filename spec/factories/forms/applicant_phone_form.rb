# frozen_string_literal: true

FactoryBot.define do
  factory :applicant_phone_form, class: WasteExemptionsEngine::ApplicantPhoneForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "applicant_phone_form"))
    end
  end
end
