# frozen_string_literal: true

FactoryBot.define do
  factory :main_people_form, class: WasteExemptionsEngine::MainPeopleForm do
    initialize_with do
      new(create(:transient_registration, workflow_state: "main_people_form"))
    end
  end
end
