# frozen_string_literal: true

FactoryBot.define do
  factory :applicant_email_form, class: WasteExemptionsEngine::ApplicantEmailForm do
    initialize_with do
      new(create(:transient_registration, workflow_state: "applicant_email_form"))
    end
  end
end
