# frozen_string_literal: true

FactoryBot.define do
  factory :check_contact_name_form, class: "WasteExemptionsEngine::CheckContactNameForm" do
    initialize_with do
      new(create(:new_registration,
                 workflow_state: "check_contact_name_form",
                 applicant_first_name: Faker::Name.first_name,
                 applicant_last_name: Faker::Name.last_name))
    end
  end
end
