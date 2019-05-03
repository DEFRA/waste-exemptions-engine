# frozen_string_literal: true

FactoryBot.define do
  factory :new_registration, class: WasteExemptionsEngine::NewRegistration do
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

    trait :complete do
      limited_company

      location { "england" }
      applicant_first_name { Faker::Name.first_name }
      applicant_last_name { Faker::Name.last_name }
      applicant_phone { "01234567890" }
      applicant_email { Faker::Internet.email }
      company_no { "09360070" }
      operator_name { Faker::Company.name }
      contact_first_name { Faker::Name.first_name }
      contact_last_name { Faker::Name.last_name }
      contact_position { Faker::Company.profession }
      contact_phone { "01234567890" }
      contact_email { Faker::Internet.email }
      on_a_farm { true }
      is_a_farmer { true }
      exemptions { WasteExemptionsEngine::Exemption.all }

      addresses do
        [
          build(:transient_address, :operator_address, :manual),
          build(:transient_address, :contact_address, :manual),
          build(:transient_address, :site_address, :manual)
        ]
      end
    end
  end
end
