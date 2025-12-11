# frozen_string_literal: true

FactoryBot.define do
  factory :front_office_edit_registration, class: "WasteExemptionsEngine::FrontOfficeEditRegistration" do
    # Create a new registration when initializing so we can copy its data
    initialize_with do
      new(reference: create(:registration, :complete).reference)
    end

    trait :modified do
      after(:build) do |edit_registration|
        edit_registration["contact_first_name"] = "#{edit_registration['contact_first_name']}_X"
      end
    end

    trait :with_all_addresses do
      # dummy trait to allow use of transient_registration shared_examples
    end

    trait :from_multisite_registration do
      # Initialize with a complete multisite registration
      initialize_with do
        new(reference: create(:registration, :complete, :multisite).reference)
      end

      after(:build) do |edit_registration|
        edit_registration.registration.site_addresses.each do |registration_site|
          # Create a transient address from the registration site
          transient_site = build(:transient_address,
                                 registration_site.attributes
                                 .except("id", "created_at", "updated_at", "registration_id"))

          edit_registration.transient_addresses << transient_site

          # Associate the exemptions from the registration site with this transient site
          registration_site.registration_exemptions.each do |reg_exemption|
            # Find the corresponding transient exemption
            transient_exemption = edit_registration.transient_registration_exemptions.find do |te|
              te.exemption_id == reg_exemption.exemption_id && te.transient_address_id.nil?
            end

            transient_exemption&.update(transient_address: transient_site)
          end
        end
      end
    end

    # ensure that all exemptions are linked to a site address
    after(:build) do |transient_registration|
      unless ENV["LEGACY_DATA_MODEL"]
        transient_address = transient_registration.transient_addresses.find do |x|
          x.address_type == "site"
        end || build(:transient_address, :site_address, :manual)
        transient_registration.transient_registration_exemptions.each do |transient_registration_exemption|
          transient_registration_exemption.transient_address = transient_address
        end
      end
    end
  end
end
