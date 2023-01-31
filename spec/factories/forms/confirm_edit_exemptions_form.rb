# frozen_string_literal: true

FactoryBot.define do
  factory :confirm_edit_exemptions_form, class: "WasteExemptionsEngine::ConfirmEditExemptionsForm" do
    initialize_with { new(create(:renewing_registration, workflow_state: "confirm_edit_exemptions_form")) }
  end
end
