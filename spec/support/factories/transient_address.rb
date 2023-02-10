# frozen_string_literal: true

FactoryBot.define do
  address_types = WasteExemptionsEngine::TransientAddress.address_types

  factory :transient_address, class: "WasteExemptionsEngine::TransientAddress" do
    uprn { 123 }

    trait :operator_address do
      premises { "Operator Premises" }
      address_type { address_types[:operator] }
    end

    trait :contact_address do
      premises { "Contact Premises" }
      address_type { address_types[:contact] }
    end

    trait :site_address do
      address_type { address_types[:site] }
    end

    trait :site_using_grid_reference do
      site_address
      mode { WasteExemptionsEngine::TransientAddress.modes[:auto] }
      description { Faker::Lorem.sentence }
      grid_reference { "ST 58337 72855" }
    end

    trait :using_postal_address do
      organisation   { Faker::Company.name }
      premises       { Faker::Address.building_number }
      street_address { Faker::Address.street_address }
      locality       { Faker::Address.city_prefix }
      city           { Faker::Address.city }
      postcode       { "BS1 5AH" }
    end

    trait :auto do
      mode { WasteExemptionsEngine::TransientAddress.modes[:auto] }
    end

    trait :manual do
      mode { WasteExemptionsEngine::TransientAddress.modes[:manual] }
    end
  end
end
