# frozen_string_literal: true

FactoryBot.define do
  factory :applicant_name_form, class: WasteExemptionsEngine::ApplicantNameForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "applicant_name_form"))
    end
  end
end
