# frozen_string_literal: true

FactoryBot.define do
  factory :transient_person, class: "WasteExemptionsEngine::TransientPerson" do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    person_type { 0 }
  end
end
