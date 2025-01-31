# frozen_string_literal: true

FactoryBot.define do
  factory :private_beta_registration_complete_form,
          class: "WasteExemptionsEngine::PrivateBetaRegistrationCompleteForm" do
    initialize_with do
      new(create(:new_charged_registration, :complete, :with_active_exemptions,
                 workflow_state: "private_beta_registration_complete_form"))
    end
  end
end
