FactoryBot.define do
  factory :charge, class: "WasteExemptionsEngine::Charge" do
    name { "#{Faker::Lorem.unique.word} charge" }
    charge_type { %w[registration_charge compliance_charge].sample }
    charge_amount { Faker::Number.between(from: 10_000, to: 99_900) }

    trait :registration_charge do
      charge_type { "registration_charge" }
    end

    trait :compliance_charge do
      charge_type { "compliance_charge" }
    end
  end
end
