# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: WasteExemptionsEngine::Registration do
    sequence :applicant_email do |n|
      "applicant#{n}@example.com"
    end

    sequence :contact_email do |n|
      "contact#{n}@example.com"
    end

    sequence :operator_name do |n|
      "Operator #{n}"
    end

    sequence :reference do |n|
      "WEX#{n}"
    end
  end
end
