# frozen_string_literal: true

FactoryBot.define do
  factory :band, class: "WasteExemptionsEngine::Band" do
    name { "Band #{Faker::Lorem.unique.word}" }
    sequence(:sequence) { Faker::Number.unique.between(from: 1, to: 99) } # reserved word

    initial_compliance_charge { association :charge, :initial_compliance_charge }
    additional_compliance_charge { association :charge, :additional_compliance_charge }

    trait :no_charges do
      initial_compliance_charge { nil }
      additional_compliance_charge { nil }
    end
  end
end
