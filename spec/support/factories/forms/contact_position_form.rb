# frozen_string_literal: true

FactoryBot.define do
  factory :contact_position_form, class: "WasteExemptionsEngine::ContactPositionForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_position_form"))
    end
  end

  factory :edit_contact_position_form, class: "WasteExemptionsEngine::ContactPositionForm" do
    initialize_with do
      new(create(:back_office_edit_registration, workflow_state: "contact_position_form"))
    end
  end

  factory :check_your_answers_edit_contact_position_form, class: "WasteExemptionsEngine::ContactPositionForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_position_form", contact_position: "Manager",
                                    temp_check_your_answers_flow: true))
    end
  end

  factory :renew_contact_position_form, class: "WasteExemptionsEngine::ContactPositionForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "contact_position_form"))
    end
  end

  factory :renewal_start_edit_contact_position_form, class: "WasteExemptionsEngine::ContactPositionForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "contact_position_form", contact_position: Faker::Lorem.word,
                                         temp_check_your_answers_flow: true))
    end
  end
end
