# frozen_string_literal: true

FactoryBot.define do
  factory :waste_activity, class: "WasteExemptionsEngine::WasteActivity" do
    name { Faker::Lorem.words(number: 3) }
    category { %w[storing_waste treating_waste disposing_of_waste using_waste].sample }
  end
end
