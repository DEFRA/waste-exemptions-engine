# frozen_string_literal: true

FactoryBot.define do
  factory :contact_phone_form, class: "WasteExemptionsEngine::ContactPhoneForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_phone_form"))
    end
  end

  factory :edit_contact_phone_form, class: "WasteExemptionsEngine::ContactPhoneForm" do
    initialize_with do
      new(create(:back_office_edit_registration, workflow_state: "contact_phone_form"))
    end
  end

  factory :check_your_answers_edit_contact_phone_form, class: "WasteExemptionsEngine::ContactPhoneForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_phone_form", contact_phone: "0123456789",
                                    temp_check_your_answers_flow: true))
    end
  end

  factory :renew_contact_phone_form, class: "WasteExemptionsEngine::ContactPhoneForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "contact_phone_form"))
    end
  end

  factory :renewal_start_edit_contact_phone_form, class: "WasteExemptionsEngine::ContactPhoneForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "contact_phone_form", contact_phone: "0123456789",
                                         temp_check_your_answers_flow: true))
    end
  end
end
