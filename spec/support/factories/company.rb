# frozen_string_literal: true

FactoryBot.define do
  factory :company, class: "WasteExemptionsEngine::Company" do
    # sequence company numbers
    sequence :company_no do |n|
      "123456#{n}"
    end
    name { "Smith Ltd" }
  end
end
