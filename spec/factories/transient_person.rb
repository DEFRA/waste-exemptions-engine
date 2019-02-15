# frozen_string_literal: true

FactoryBot.define do
  factory :transient_person, class: WasteExemptionsEngine::TransientPerson do
    sequence(:first_name) { |n| "Joe#{n}" }
    sequence(:last_name) { |n| "Bloggs#{n}" }
    person_type { 0 }
  end
end
