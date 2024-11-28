# frozen_string_literal: true

FactoryBot.define do
  factory :waste_activity, class: "WasteExemptionsEngine::WasteActivity" do
    name { Faker::Lorem.words(number: 3) }
    category { WasteExemptionsEngine::WasteActivity::ACTIVITY_CATEGORIES.values.sample }
  end
end
