# frozen_string_literal: true

FactoryBot.define do
  address_types = WasteExemptionsEngine::TransientAddress.address_types

  factory :transient_address, class: WasteExemptionsEngine::TransientAddress do
    trait :operator_address do
      address_type { address_types[:operator] }
    end

    trait :contact_address do
      address_type { address_types[:contact] }
    end

    trait :site_address do
      address_type { address_types[:site] }
    end

    trait :site_using_a_manual_address do
      site_address
      manual
      premises { Faker::Address.community }
      street_address { Faker::Address.street_address }
      locality { Faker::Address.country }
      city { Faker::Address.city }
      postcode { "BS1 5AH" }
    end

    trait :site_using_invalid_manual_address do
      site_using_a_manual_address
      postcode { "BS1 9XX" }
    end

    trait :site_using_grid_reference do
      site_address
      mode { WasteExemptionsEngine::TransientAddress.modes[:auto] }
      description { Faker::Lorem.sentence }
      grid_reference { "ST 58337 72855" }
    end

    trait :site_using_invalid_grid_reference do
      site_using_grid_reference
      grid_reference { "ZZ 00001 00001" }
    end

    trait :manual do
      mode { WasteExemptionsEngine::TransientAddress.modes[:manual] }
    end
  end
end
