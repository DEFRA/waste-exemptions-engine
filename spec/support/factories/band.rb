# frozen_string_literal: true

FactoryBot.define do
  factory :band, class: "WasteExemptionsEngine::Band" do
    name { "Band #{Faker::Lorem.word}" }
    sequence(:sequence) { Faker::Number.between(from: 1, to: 10) } # reserved word
    registration_fee { Faker::Number.between(from: 1000, to: 9900) }
    initial_compliance_charge { Faker::Number.between(from: 10_000, to: 99_900) }
    additional_compliance_charge { Faker::Number.between(from: 10_000, to: 99_900) }
  end
end
