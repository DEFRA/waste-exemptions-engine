# frozen_string_literal: true

FactoryBot.define do
  factory :site_address_lookup_form, class: "WasteExemptionsEngine::SiteAddressLookupForm" do
    initialize_with do
      new(
        create(:new_registration,
               workflow_state: "site_address_lookup_form",
               temp_site_postcode: "BS1 5AH")
      )
    end
  end
end
