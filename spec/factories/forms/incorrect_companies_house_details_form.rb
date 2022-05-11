# frozen_string_literal: true

FactoryBot.define do
  factory :incorrect_companies_house_details_form, class: WasteExemptionsEngine::IncorrectCompaniesHouseDetailsForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "incorrect_companies_house_details_form"))
    end
  end
end
