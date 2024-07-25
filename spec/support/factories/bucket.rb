# frozen_string_literal: true

FactoryBot.define do
  factory :bucket, class: "WasteExemptionsEngine::Bucket" do
    name { "Bucket #{Faker::Lorem.unique.word}" }
    initial_compliance_charge { association :charge, :initial_compliance_charge }

    trait :farmer_exemptions do
      name { "Farmer exemptions" }
      bucket_type { "farmer" }
    end
  end
end
