# frozen_string_literal: true

FactoryBot.define do
  factory :renewal_start_form, class: WasteExemptionsEngine::RenewalStartForm do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "renewal_start_form"))
    end
  end
end
