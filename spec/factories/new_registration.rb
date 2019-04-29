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
      location { "england" }
      applicant_first_name { "Joe" }
      applicant_last_name { "Bloggs" }
      applicant_phone { "01234567890" }
      applicant_email { "test@example.com" }
      business_type { "limitedCompany" }
      company_no { "09360070" }
      operator_name { "Acme Waste Management" }
      contact_first_name { "Joe" }
      contact_last_name { "Bloggs" }
      contact_position { "Chief Waste Carrier" }
      contact_phone { "01234567890" }
      contact_email { "test@example.com" }
      on_a_farm { true }
      is_a_farmer { true }
      exemptions { WasteExemptionsEngine::Exemption.all }

      after(:create) do |new_registration|
        new_registration.addresses = [
          create(:transient_address, :operator_address, :manual),
          create(:transient_address, :contact_address, :manual),
          create(:transient_address, :site_address, :manual)
        ]
      end
    end
  end
end
