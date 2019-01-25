# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: WasteExemptionsEngine::Registration do
    sequence :reference do |n|
      "WEX#{n}"
    end
  end
end
