# frozen_string_literal: true

FactoryBot.define do
  factory :new_charged_registration, class: "WasteExemptionsEngine::NewChargedRegistration" do
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

    trait :has_no_email do
      contact_email { nil }
    end

    trait :has_people do
      people { build_list(:transient_person, 2) }
    end

    trait :has_company_no do
      company_no { "09360070" }
    end

    trait :with_all_addresses do
      addresses do
        [
          build(:transient_address, :operator_address, :using_postal_address, :manual),
          build(:transient_address, :contact_address, :using_postal_address, :manual),
          build(:transient_address, :site_using_grid_reference, :auto)
        ]
      end
    end

    trait :with_active_exemptions do
      transient_registration_exemptions do
        build_list(:transient_registration_exemption, 3, :expires_on, :registered_on)
      end
    end
  end
end
