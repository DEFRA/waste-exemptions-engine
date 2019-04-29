# frozen_string_literal: true

FactoryBot.define do
  factory :site_postcode_form, class: WasteExemptionsEngine::SitePostcodeForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "site_postcode_form"))
    end
  end
end
