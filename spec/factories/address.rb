# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: WasteExemptionsEngine::Address do
    sequence :postcode do |n|
      "BS#{n}AA"
    end

    address_type { 0 }

    trait :operator do
      address_type { 1 }
    end

    trait :contact do
      address_type { 2 }
    end

    trait :site do
      address_type { 3 }
    end
  end
end
