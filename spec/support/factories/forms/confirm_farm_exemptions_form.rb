# frozen_string_literal: true

FactoryBot.define do
  factory :confirm_farm_exemptions_form, class: "WasteExemptionsEngine::ConfirmFarmExemptionsForm" do
    initialize_with { new(create(:new_charged_registration, workflow_state: "confirm_farm_exemptions_form")) }
  end

  factory :new_charged_registration_flow_confirm_farm_exemptions_form,
          class: "WasteExemptionsEngine::ConfirmFarmExemptionsForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "confirm_farm_exemptions_form"))
    end
  end
end
