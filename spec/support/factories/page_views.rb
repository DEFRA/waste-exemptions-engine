# frozen_string_literal: true

FactoryBot.define do
  factory :page_view, class: "Analytics::PageView" do
    page { "MyString" }
    time { "2024-02-22 14:57:17" }
    route { "MyString" }
    user_journey { nil }
  end
end
