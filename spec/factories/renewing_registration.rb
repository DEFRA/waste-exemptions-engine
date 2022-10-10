# frozen_string_literal: true

FactoryBot.define do
  factory :renewing_registration, class: "WasteExemptionsEngine::RenewingRegistration" do
    # Create a new registration when initializing so we can copy its data
    initialize_with do
      registration = create(:registration, :complete)

      new(reference: registration.reference, token: registration.renew_token)
    end

    trait :with_manual_site_address do
      initialize_with do
        new(reference: create(:registration, :complete, :with_manual_site_address).reference)
      end
    end

    trait :with_all_addresses do
      addresses do
        [
          build(:transient_address, :operator_address, :manual),
          build(:transient_address, :contact_address, :manual),
          build(:transient_address, :site_address, :manual)
        ]
      end
    end

    factory :renewing_registration_without_changes do
      temp_renew_without_changes { true }
    end

    factory :renewing_registration_with_manual_site_address do
      initialize_with do
        registration = create(:registration, :complete, :with_manual_site_address)

        new(reference: registration.reference, token: registration.renew_token)
      end
    end
  end
end
