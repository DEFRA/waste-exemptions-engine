# frozen_string_literal: true

FactoryBot.define do
  address_types = WasteExemptionsEngine::Address.address_types

  factory :address, class: WasteExemptionsEngine::Address do
    trait :operator_address do
      address_type { address_types[:operator] }
    end

    trait :contact_address do
      address_type { address_types[:contact] }
    end

    trait :site_address do
      address_type { address_types[:site] }
      description { Faker::Lorem.sentence }
      grid_reference { "ST 58337 72855" }
    end

    trait :postal do
      sequence :postcode do |n|
        "BS#{n}AA"
      end

      uprn { Faker::Alphanumeric.unique.alphanumeric(8) }
      premises { Faker::Address.community }
      street_address { Faker::Address.street_address }
      locality { Faker::Address.country }
      city { Faker::Address.city }
    end

    trait :manual do
      mode { WasteExemptionsEngine::TransientAddress.modes[:manual] }
    end
  end
end
