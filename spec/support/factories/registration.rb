# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: "WasteExemptionsEngine::Registration" do
    # Normally the reference would be created in the transient_registration and
    # then transferred. However, since we're creating this Registration out of
    # thin air, we need to generate it here. Format should be WEX900001 to
    # avoid clashes with other Registrations, where the reference is based on
    # the id of the original TransientRegistration.
    sequence :reference do |n|
      format("WEX9%<id>05d", id: n)
    end

    trait :with_active_exemptions do
      registration_exemptions { build_list(:registration_exemption, 3, state: :active) }
    end

    trait :with_expired_exemptions do
      registration_exemptions { build_list(:registration_exemption, 3, state: :expired) }
    end

    trait :with_ceased_exemptions do
      registration_exemptions { build_list(:registration_exemption, 3, state: :ceased) }
    end

    trait :with_expired_and_active_exemptions do
      registration_exemptions { build_list(:registration_exemption, 3, state: %i[expired active].sample) }
    end

    trait :limited_company do
      business_type { WasteExemptionsEngine::Registration::BUSINESS_TYPES[:limited_company] }
    end

    trait :limited_liability_partnership do
      business_type { WasteExemptionsEngine::Registration::BUSINESS_TYPES[:limited_liability_partnership] }
    end

    trait :local_authority do
      business_type { WasteExemptionsEngine::Registration::BUSINESS_TYPES[:local_authority] }
    end

    trait :charity do
      business_type { WasteExemptionsEngine::Registration::BUSINESS_TYPES[:charity] }
    end

    trait :partnership do
      business_type { WasteExemptionsEngine::Registration::BUSINESS_TYPES[:partnership] }
      people { build_list(:person, 2) }
    end

    trait :sole_trader do
      business_type { WasteExemptionsEngine::Registration::BUSINESS_TYPES[:sole_trader] }
      company_no { nil }
    end

    trait :with_manual_site_address do
      addresses do
        [build(:address, :operator_address, :postal),
         build(:address, :contact_address, :postal),
         build(:address, :site_address, :manual, :postal)]
      end
    end

    trait :with_lookup_site_address do
      addresses do
        [build(:address, :operator_address, :postal),
         build(:address, :contact_address, :postal),
         build(:address, :site_address, :lookup, :postal)]
      end
    end

    trait :past_renewal_window do
      registration_exemptions { build_list(:registration_exemption, 10, :past_renewal_window) }
    end

    trait :in_renewal_window do
      registration_exemptions { build_list(:registration_exemption, 10, :in_renewal_window) }
    end

    trait :complete do
      submitted_at { Date.today }
      location { "england" }
      applicant_first_name { Faker::Name.first_name }
      applicant_last_name { Faker::Name.last_name }
      applicant_phone { "01234567890" }
      applicant_email { Faker::Internet.email }
      business_type { WasteExemptionsEngine::Registration::BUSINESS_TYPES[:limited_company] }
      company_no { "09360070" }
      operator_name { Faker::Company.name }
      contact_first_name { Faker::Name.first_name }
      contact_last_name { Faker::Name.last_name }
      contact_position { Faker::Company.profession }
      contact_phone { "01234567890" }
      contact_email { Faker::Internet.email }
      on_a_farm { true }
      is_a_farmer { true }
      registration_exemptions { build_list(:registration_exemption, 10) }
      people { build_list(:person, 3) }

      addresses do
        [
          build(:address, :operator_address, :postal),
          build(:address, :contact_address, :postal),
          build(:address, :site_using_grid_reference, :auto)
        ]
      end
    end

    trait :with_short_site_description do
      addresses do
        [build(:address, :operator_address),
         build(:address, :contact_address),
         build(:address, :site_using_grid_reference, :short_description)]
      end
    end

    trait :with_long_site_description do
      addresses do
        [build(:address, :operator_address),
         build(:address, :contact_address),
         build(:address, :site_using_grid_reference, :long_description)]
      end
    end
  end
end
