# frozen_string_literal: true

FactoryBot.define do
  factory :contact_email_form, class: WasteExemptionsEngine::ContactEmailForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_email_form"))
    end
  end

  factory :edit_contact_email_form, class: WasteExemptionsEngine::ContactEmailForm do
    initialize_with do
      new(create(:edit_registration, workflow_state: "contact_email_form"))
    end
  end

  factory :renew_contact_email_form, class: WasteExemptionsEngine::ContactEmailForm do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "contact_email_form"))
    end
  end
end
