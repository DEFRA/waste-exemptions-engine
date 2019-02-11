# frozen_string_literal: true

FactoryBot.define do
  factory :contact_postcode_form, class: WasteExemptionsEngine::ContactPostcodeForm do
    initialize_with do
      new(create(:transient_registration, workflow_state: "contact_postcode_form"))
    end
  end
end
