# frozen_string_literal: true

FactoryBot.define do
  factory :applicant_name_form, class: "WasteExemptionsEngine::ApplicantNameForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "applicant_name_form"))
    end
  end

  factory :edit_applicant_name_form, class: "WasteExemptionsEngine::ApplicantNameForm" do
    initialize_with do
      new(create(:edit_registration, workflow_state: "applicant_name_form"))
    end
  end

  factory :renew_applicant_name_form, class: "WasteExemptionsEngine::ApplicantNameForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "applicant_name_form"))
    end
  end
end
