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
      people { build_list(:person, 2, :partner) }
    end

    trait :sole_trader do
      business_type { "soleTrader" }
    end

    trait :with_manual_site_address do
      addresses { [build(:address, :site_address, :manual)] }
    end

    trait :confirmable do
      reference { "WEX000999" }
      submitted_at { Date.today }
      limited_company
      people { [build(:person)] }

      applicant_first_name { "Applicant First Name" }
      applicant_last_name { "Applicant Last Name" }
      applicant_phone { "07459745569" }
      applicant_email { "applicant@test.defra.gov.uk" }

      operator_name { "Operator name" }

      contact_first_name { "Contact First Name" }
      contact_last_name { "Contact Last Name" }
      contact_phone { "07459745569" }
      contact_email { "contact@test.defra.gov.uk" }
      contact_position { "Manager" }

      addresses { [build(:address, :site_address, :auto), build(:address, :operator_address, :manual), build(:address, :contact_address, :manual)] }

      after(:build) do |registration|
        exemption = build(:exemption, code: "U6")
        registration_exemption = build(:registration_exemption, exemption: exemption)

        registration.registration_exemptions << registration_exemption
      end
    end
  end
end
