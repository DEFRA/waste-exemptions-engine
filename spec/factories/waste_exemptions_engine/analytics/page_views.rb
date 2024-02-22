FactoryBot.define do
  factory :analytics_page_view, class: 'Analytics::PageView' do
    page { "MyString" }
    time { "2024-02-22 14:57:17" }
    route { "MyString" }
    user_journey { nil }
  end
end
