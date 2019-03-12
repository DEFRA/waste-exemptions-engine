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
      description { "The waste is stored in an out-building next to the barn." }
      grid_reference { "ST 58337 72855" }
    end

    trait :manual do
      mode { WasteExemptionsEngine::TransientAddress.modes[:manual] }
    end
  end
end
