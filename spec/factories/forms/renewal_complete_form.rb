# frozen_string_literal: true

FactoryBot.define do
  factory :renewal_complete_form, class: "WasteExemptionsEngine::RenewalCompleteForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "renewal_complete_form"))
    end
  end
end
