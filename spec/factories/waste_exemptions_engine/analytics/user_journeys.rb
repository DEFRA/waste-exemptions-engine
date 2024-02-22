FactoryBot.define do
  factory :analytics_user_journey, class: 'Analytics::UserJourney' do
    journey_type { "MyString" }
    completed_at { "2024-02-22 14:59:23" }
    token { "MyString" }
    user { "MyString" }
    started_route { "MyString" }
    completed_route { "MyString" }
    registration_data { "MyText" }
  end
end
