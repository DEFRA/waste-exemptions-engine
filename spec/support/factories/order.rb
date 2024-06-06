# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: "WasteExemptionsEngine::Order" do

    trait :with_exemptions do
      exemptions { build_list(:exemption, 3, band: build(:band)) }
    end

    trait :with_bucket do
      association :bucket
    end
  end
end
