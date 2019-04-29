# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: WasteExemptionsEngine::Registration do
    # Normally the reference would be created in the transient_registration and
    # then transferred. However, since we're creating this Registration out of
    # thin air, we need to generate it here. Format should be WEX900001 to
    # avoid clashes with other Registrations, where the reference is based on
    # the id of the original TransientRegistration.
    sequence :reference do |n|
      format("WEX9%05d", n)
    end

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
      addresses { [build(:address, :site_address)] }
    end

    trait :confirmable do
      emailable
      company_no { "123123456" }
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
      exemptions { build_list(:exemption, 10) }
      people { build_list(:person, 3) }

      addresses do
        [build(:address, :operator_address, :postal),
         build(:address, :contact_address, :postal),
         build(:address, :site_address)]
      end
    end
  end
end
