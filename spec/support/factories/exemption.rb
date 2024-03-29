# frozen_string_literal: true

FactoryBot.define do
  factory :exemption, class: "WasteExemptionsEngine::Exemption" do

    sequence :code do |n|
      "U#{n}"
    end

    category { WasteExemptionsEngine::Exemption.categories[:using_waste] }
    url { "https://www.gov.uk/guidance/waste-exemptions-#{code}-using--waste" }
    summary { Faker::Lorem.sentence }

    trait :hidden do
      hidden { true }
    end
  end
end
