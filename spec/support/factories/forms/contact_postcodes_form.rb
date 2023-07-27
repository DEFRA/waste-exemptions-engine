# frozen_string_literal: true

FactoryBot.define do
  factory :contact_postcode_form, class: "WasteExemptionsEngine::ContactPostcodeForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_postcode_form"))
    end
  end

  factory :edit_contact_postcode_form, class: "WasteExemptionsEngine::ContactPostcodeForm" do
    initialize_with do
      new(create(:back_office_edit_registration, workflow_state: "contact_postcode_form"))
    end
  end

  factory :renew_contact_postcode_form, class: "WasteExemptionsEngine::ContactPostcodeForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "contact_postcode_form"))
    end
  end
end
