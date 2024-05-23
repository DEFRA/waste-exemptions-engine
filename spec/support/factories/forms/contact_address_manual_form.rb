# frozen_string_literal: true

FactoryBot.define do
  factory :contact_address_manual_form, class: "WasteExemptionsEngine::ContactAddressManualForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_address_manual_form"))
    end
  end

  factory :check_your_answers_contact_address_manual_form, class: "WasteExemptionsEngine::ContactAddressManualForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_address_manual_form", temp_check_your_answers_flow: true))
    end
  end
end
