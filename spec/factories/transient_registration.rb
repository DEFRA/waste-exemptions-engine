# frozen_string_literal: true

FactoryBot.define do
  factory :transient_registration, class: WasteExemptionsEngine::TransientRegistration do
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
      transient_addresses do
        address_types = WasteExemptionsEngine::TransientAddress.address_types
        [
          create(:transient_address, address_type: address_types[:operator]),
          create(:transient_address, address_type: address_types[:contact]),
          create(:transient_address, address_type: address_types[:site])
        ]
      end

      location { "england" }
      applicant_first_name { "Joe" }
      applicant_last_name { "Bloggs" }
      applicant_phone { "01234567890" }
      applicant_email { "test@example.com" }
      business_type { "limitedCompany" }
      company_no { "sc534714" }
      operator_name { "Acme Waste Management" }
      contact_first_name { "Joe" }
      contact_last_name { "Bloggs" }
      contact_position { "Chief Waste Carrier" }
      contact_phone { "01234567890" }
      contact_email { "test@example.com" }
      on_a_farm { true }
      is_a_farmer { true }
      exemptions { WasteExemptionsEngine::Exemption.all }
    end
  end
end
