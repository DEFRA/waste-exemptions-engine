# frozen_string_literal: true

FactoryBot.define do
  factory :check_contact_address_form, class: "WasteExemptionsEngine::CheckContactAddressForm" do
    initialize_with do
      new(create(:new_registration,
                 workflow_state: "check_contact_address_form",
                 operator_address: create(:transient_address, :operator_address)))
    end
  end
end
