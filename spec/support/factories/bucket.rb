# frozen_string_literal: true

FactoryBot.define do
  factory :bucket, class: "WasteExemptionsEngine::Bucket" do
    name { "Bucket #{Faker::Lorem.word}" }
    charge_amount { Faker::Number.between(from: 10_000, to: 99_900) }

    trait :farmer_exemptions do
      name { "Farmer exemptions" }
    end
  end
end
