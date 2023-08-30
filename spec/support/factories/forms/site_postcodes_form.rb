# frozen_string_literal: true

FactoryBot.define do
  factory :site_postcode_form, class: "WasteExemptionsEngine::SitePostcodeForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "site_postcode_form"))
    end
  end

  factory :edit_site_postcode_form, class: "WasteExemptionsEngine::SitePostcodeForm" do
    initialize_with do
      new(create(:back_office_edit_registration, :with_manual_site_address, workflow_state: "site_postcode_form"))
    end
  end

  factory :renew_site_postcode_form, class: "WasteExemptionsEngine::SitePostcodeForm" do
    initialize_with do
      new(create(:renewing_registration, :with_manual_site_address, workflow_state: "site_postcode_form"))
    end
  end
end
