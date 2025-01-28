# frozen_string_literal: true

FactoryBot.define do
  factory :no_farm_exemptions_selected_form, class: "WasteExemptionsEngine::NoFarmExemptionsSelectedForm" do
    initialize_with { new(create(:new_charged_registration, workflow_state: "no_farm_exemptions_selected_form")) }
  end
end
