# frozen_string_literal: true

FactoryBot.define do
  factory :check_site_address_form, class: WasteExemptionsEngine::CheckSiteAddressForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "check_site_address_form"))
    end
  end
end
