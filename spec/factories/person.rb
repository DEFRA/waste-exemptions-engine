# frozen_string_literal: true

FactoryBot.define do
  factory :person, class: "WasteExemptionsEngine::Person" do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    person_type { :partner }
  end
end
