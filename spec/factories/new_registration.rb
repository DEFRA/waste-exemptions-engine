# frozen_string_literal: true

FactoryBot.define do
  factory :new_registration, class: WasteExemptionsEngine::NewRegistration do
    trait :limited_company do
      business_type { WasteExemptionsEngine::NewRegistration::BUSINESS_TYPES[:limited_company] }
    end

    trait :limited_liability_partnership do
      business_type { WasteExemptionsEngine::NewRegistration::BUSINESS_TYPES[:limited_liability_partnership] }
    end

    trait :local_authority do
      business_type { WasteExemptionsEngine::NewRegistration::BUSINESS_TYPES[:local_authority] }
    end

    trait :charity do
      business_type { WasteExemptionsEngine::NewRegistration::BUSINESS_TYPES[:charity] }
    end

    trait :partnership do
      business_type { WasteExemptionsEngine::NewRegistration::BUSINESS_TYPES[:partnership] }
    end

    trait :sole_trader do
      business_type { WasteExemptionsEngine::NewRegistration::BUSINESS_TYPES[:sole_trader] }
    end

    trait :same_applicant_and_contact_email do
      contact_email { applicant_email }
    end

    trait :has_people do
      people { build_list(:transient_person, 2) }
    end

    trait :complete do
      limited_company

      location { "england" }
      applicant_first_name { Faker::Name.first_name }
      applicant_last_name { Faker::Name.last_name }
      applicant_phone { "01234567890" }
      applicant_email { Faker::Internet.safe_email }
      company_no { "09360070" }
      operator_name { Faker::Company.name }
      contact_first_name { Faker::Name.first_name }
      contact_last_name { Faker::Name.last_name }
      contact_position { Faker::Company.profession }
      contact_phone { "01234567890" }
      contact_email { Faker::Internet.safe_email }
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
