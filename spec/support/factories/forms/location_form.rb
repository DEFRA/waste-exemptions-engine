# frozen_string_literal: true

FactoryBot.define do
  factory :location_form, class: "WasteExemptionsEngine::LocationForm" do

    model_factory { :new_registration }

    trait :charged do
      model_factory { :new_charged_registration }
    end

    initialize_with do
      new(create(model_factory, workflow_state: "location_form"))
    end
  end
end
