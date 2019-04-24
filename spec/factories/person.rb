# frozen_string_literal: true

FactoryBot.define do
  factory :person, class: WasteExemptionsEngine::Person do
    trait :partner do
      person_type { :partner }

      first_name { "Partner first name" }
      last_name { "Partner last name" }
    end
  end
end
