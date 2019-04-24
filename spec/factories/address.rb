# frozen_string_literal: true

FactoryBot.define do
  address_types = WasteExemptionsEngine::Address.address_types
  modes = WasteExemptionsEngine::Address.modes

  factory :address, class: WasteExemptionsEngine::Address do
    trait :manual do
      mode { modes[:manual] }
      premises { "#{address_type} Address Premises" }
      street_address { "#{address_type} 34 Honey road" }
      locality { "#{address_type} Avon" }
      city { "#{address_type} Bristol" }
      postcode { "#{address_type} BS1 5AH" }
    end

    trait :auto do
      mode { modes[:auto] }
      description { "The waste is stored in an out-building next to the barn." }
      grid_reference { "ST 58337 72855" }
    end

    trait :operator_address do
      address_type { address_types[:operator] }
    end

    trait :contact_address do
      address_type { address_types[:contact] }
    end

    trait :site_address do
      address_type { address_types[:site] }
    end

    trait :manual do
      mode { WasteExemptionsEngine::TransientAddress.modes[:manual] }
    end
  end
end
