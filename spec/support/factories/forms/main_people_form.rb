# frozen_string_literal: true

FactoryBot.define do
  factory :main_people_form, class: "WasteExemptionsEngine::MainPeopleForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "main_people_form"))
    end
  end

  factory :check_your_answers_edit_main_people_form, class: "WasteExemptionsEngine::MainPeopleForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "main_people_form", people: [create(:transient_person)],
                                    temp_check_your_answers_flow: true))
    end
  end
end
