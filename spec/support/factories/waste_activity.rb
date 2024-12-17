# frozen_string_literal: true

FactoryBot.define do
  factory :waste_activity, class: "WasteExemptionsEngine::WasteActivity" do
    name { Faker::Lorem.sentence }
    name_gerund { name }
    category { WasteExemptionsEngine::WasteActivity::ACTIVITY_CATEGORIES.keys.sample }
  end
end
