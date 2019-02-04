# frozen_string_literal: true

FactoryBot.define do
  factory :transient_registration, class: WasteExemptionsEngine::TransientRegistration do
    trait :limited_company do
      business_type { "limitedCompany" }
    end
  end
end
