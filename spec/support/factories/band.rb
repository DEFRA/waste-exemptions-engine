# frozen_string_literal: true

FactoryBot.define do
  factory :band, class: "WasteExemptionsEngine::Band" do
    name { "Band #{Faker::Lorem.unique.word}" }
    sequence(:sequence) { Faker::Number.unique.between(from: 1, to: 99) } # reserved word

    trait :with_charges do
      initial_compliance_charge { association :charge, :initial_compliance_charge }
      additional_compliance_charge { association :charge, :additional_compliance_charge }
    end
  end
end
