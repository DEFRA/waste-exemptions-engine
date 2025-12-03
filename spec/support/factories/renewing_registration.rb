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

    trait :from_multisite_registration do
      # Initialize with a complete multisite registration
      initialize_with do
        registration = create(:registration, :complete, :multisite_complete)
        new(reference: registration.reference, token: registration.renew_token)
      end

      after(:build) do |renewing_registration|
        # The :multisite trait creates 3 site addresses by default
        # Copy them to transient addresses
        renewing_registration.registration.site_addresses.each do |registration_site|
          # Create a transient address from the registration site
          transient_site = build(:transient_address,
                                 registration_site.attributes
                                 .except("id", "created_at", "updated_at", "registration_id"))

          renewing_registration.transient_addresses << transient_site

          # Associate the exemptions from the registration site with this transient site
          registration_site.registration_exemptions.each do |reg_exemption|
            # Find the corresponding transient exemption
            transient_exemption = renewing_registration.transient_registration_exemptions.find do |te|
              te.exemption_id == reg_exemption.exemption_id && te.transient_address_id.nil?
            end

            transient_exemption&.update(transient_address: transient_site)
          end
        end
      end
    end

    factory :renewing_registration_with_manual_site_address do
      initialize_with do
        registration = create(:registration, :complete, :with_manual_site_address)

        new(reference: registration.reference, token: registration.renew_token)
      end
    end
  end
end
