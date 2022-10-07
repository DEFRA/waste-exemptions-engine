# frozen_string_literal: true

FactoryBot.define do
  factory :check_contact_email_form, class: "WasteExemptionsEngine::CheckContactEmailForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "check_contact_email_form", applicant_email: Faker::Internet.email))
    end
  end
end
