# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: WasteExemptionsEngine::Address do
    sequence :postcode do |n|
      "BS#{n}AA"
    end
  end
end
