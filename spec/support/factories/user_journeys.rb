# frozen_string_literal: true

FactoryBot.define do
  factory :user_journey, class: "WasteExemptionsEngine::Analytics::UserJourney" do
    journey_type { "MyString" }
    completed_at { "2024-02-22 14:59:23" }
    token { "MyString" }
    user { "MyString" }
    started_route { "DIGITAL" }
    completed_route { "MyString" }
    registration_data { {} }
  end
end
