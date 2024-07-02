# frozen_string_literal: true

FactoryBot.define do
  factory :check_site_address_form, class: "WasteExemptionsEngine::CheckSiteAddressForm" do
    initialize_with do
      new(
        create(:new_registration,
               workflow_state: "check_site_address_form",
               operator_address: create(:transient_address, :operator_address),
               contact_address: create(:transient_address, :contact_address))
      )
    end
  end

  factory :check_your_answers_check_site_address_form, class: "WasteExemptionsEngine::CheckSiteAddressForm" do
    initialize_with do
      new(
        create(:new_registration,
               workflow_state: "check_site_address_form",
               operator_address: create(:transient_address, :operator_address),
               contact_address: create(:transient_address, :contact_address),
               temp_check_your_answers_flow: true)
      )
    end
  end
end
