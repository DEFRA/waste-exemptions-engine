# frozen_string_literal: true

FactoryBot.define do
  factory :location_form, class: WasteExemptionsEngine::LocationForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "location_form"))
    end
  end
end
