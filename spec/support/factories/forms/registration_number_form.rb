# frozen_string_literal: true

FactoryBot.define do
  factory :registration_number_form, class: "WasteExemptionsEngine::RegistrationNumberForm" do
    initialize_with { new(create(:new_registration, workflow_state: "registration_number_form")) }
  end

  factory :check_your_answers_edit_registration_number_form, class: "WasteExemptionsEngine::RegistrationNumberForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "registration_number_form",
                                    temp_company_no: "09360070",
                                    temp_check_your_answers_flow: true))
    end
  end
end
