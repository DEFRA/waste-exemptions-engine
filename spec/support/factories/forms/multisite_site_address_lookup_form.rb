# frozen_string_literal: true

FactoryBot.define do
  factory :multisite_site_address_lookup_form, class: "WasteExemptionsEngine::MultisiteSiteAddressLookupForm" do
    trait :charged do
      # no additional setup needed - factory already uses charged registration
    end

    initialize_with do
      new(
        create(:new_charged_registration,
               is_multisite_registration: true,
               workflow_state: "multisite_site_address_lookup_form",
               temp_site_postcode: "BS1 5AH")
      )
    end
  end

end
