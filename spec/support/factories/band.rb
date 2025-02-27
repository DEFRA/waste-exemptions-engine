# frozen_string_literal: true

FactoryBot.define do
  factory :band, class: "WasteExemptionsEngine::Band" do
    sequence(:name) { |n| "Band #{Faker::Lorem.word}_#{n}" }
    sequence(:sequence) { Faker::Number.unique.between(from: 1, to: 99_999) } # "sequence" is a reserved word

    initial_compliance_charge { association :charge, :initial_compliance_charge }
    additional_compliance_charge { association :charge, :additional_compliance_charge }

    trait :no_charges do
      initial_compliance_charge { nil }
      additional_compliance_charge { nil }
    end
  end
end
