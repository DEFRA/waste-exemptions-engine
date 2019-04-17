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

    # This is the minimum needed to be able to generate a confirmation email
    # and its attachments sucessfully
    trait :emailable do
      reference { "WEX000999" }
      submitted_at { Date.today }
      addresses { [create(:address, :site_address)] }
    end

    trait :confirmable do
      emailable
      company_no { "123123456" }
    end
  end
end
