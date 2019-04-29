# frozen_string_literal: true

FactoryBot.define do
  factory :contact_email_form, class: WasteExemptionsEngine::ContactEmailForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_email_form"))
    end
  end
end
