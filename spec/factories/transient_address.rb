# frozen_string_literal: true

FactoryBot.define do
  address_types = WasteExemptionsEngine::TransientAddress.address_types

  factory :transient_address, class: WasteExemptionsEngine::TransientAddress do
    uprn { 123 }

    trait :operator_address do
      address_type { address_types[:operator] }
    end

    trait :contact_address do
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

    trait :manual do
      mode { WasteExemptionsEngine::TransientAddress.modes[:manual] }
    end
  end
end
