# frozen_string_literal: true

FactoryBot.define do
  factory :site_address_manual_form, class: WasteExemptionsEngine::SiteAddressManualForm do
    initialize_with do
      new(create(:transient_registration, workflow_state: "site_address_manual_form"))
    end
  end
end
