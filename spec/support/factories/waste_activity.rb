# frozen_string_literal: true

FactoryBot.define do
  factory :waste_activity, class: "WasteExemptionsEngine::WasteActivity" do
    name { "MyString" }
    category { 1 }
  end
end
