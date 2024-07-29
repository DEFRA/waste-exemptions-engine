# frozen_string_literal: true

FactoryBot.define do
  factory :contact_name_form, class: "WasteExemptionsEngine::ContactNameForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_name_form"))
    end
  end

  factory :edit_contact_name_form, class: "WasteExemptionsEngine::ContactNameForm" do
    initialize_with do
      new(create(:back_office_edit_registration, workflow_state: "contact_name_form"))
    end
  end

  factory :check_your_answers_edit_contact_name_form, class: "WasteExemptionsEngine::ContactNameForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_name_form", contact_first_name: "Joe",
                                    contact_last_name: "Bloggs", temp_check_your_answers_flow: true))
    end
  end

  factory :renew_contact_name_form, class: "WasteExemptionsEngine::ContactNameForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "contact_name_form"))
    end
  end

  factory :renewal_start_edit_contact_name_form, class: "WasteExemptionsEngine::ContactNameForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "contact_name_form", contact_first_name: "Joe",
                                         contact_last_name: "Bloggs", temp_check_your_answers_flow: true))
    end
  end
end
