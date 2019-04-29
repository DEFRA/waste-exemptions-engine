# frozen_string_literal: true

FactoryBot.define do
  factory :contact_agency_form, class: WasteExemptionsEngine::ContactAgencyForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_agency_form"))
    end
  end
end
