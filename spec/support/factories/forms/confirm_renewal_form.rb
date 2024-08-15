# frozen_string_literal: true

FactoryBot.define do
  factory :confirm_renewal_form, class: "WasteExemptionsEngine::ConfirmRenewalForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "confirm_renewal_form"))
    end
  end
end
