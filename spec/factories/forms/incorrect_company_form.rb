# frozen_string_literal: true

FactoryBot.define do
  factory :incorrect_company_form, class: WasteExemptionsEngine::IncorrectCompanyForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "incorrect_company_form"))
    end
  end
end
