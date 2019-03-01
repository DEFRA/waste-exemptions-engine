# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: WasteExemptionsEngine::Registration do
    trait :limited_company do
      business_type { "limitedCompany" }
    end

    trait :limited_liability_partnership do
      business_type { "limitedLiabilityPartnership" }
    end

    trait :local_authority do
      business_type { "localAuthority" }
    end

    trait :charity do
      business_type { "charity" }
    end

    trait :partnership do
      business_type { "partnership" }
    end

    trait :sole_trader do
      business_type { "soleTrader" }
    end
  end
end
