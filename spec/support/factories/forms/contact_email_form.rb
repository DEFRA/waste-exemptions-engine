# frozen_string_literal: true

FactoryBot.define do
  factory :contact_email_form, class: "WasteExemptionsEngine::ContactEmailForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_email_form"))
    end
  end

  factory :edit_contact_email_form, class: "WasteExemptionsEngine::ContactEmailForm" do
    initialize_with do
      new(create(:back_office_edit_registration, workflow_state: "contact_email_form"))
    end
  end

  factory :check_your_answers_edit_contact_email_form, class: "WasteExemptionsEngine::ContactEmailForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_email_form", contact_email: "test@test.com",
                                    temp_check_your_answers_flow: true))
    end
  end

  factory :renew_contact_email_form, class: "WasteExemptionsEngine::ContactEmailForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "contact_email_form"))
    end
  end

  factory :renewal_start_edit_contact_email_form, class: "WasteExemptionsEngine::ContactEmailForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "contact_email_form", contact_email: "test@test.com",
                                         temp_check_your_answers_flow: true))
    end
  end
end
