# frozen_string_literal: true

FactoryBot.define do
  factory :exemptions_form, class: WasteExemptionsEngine::ExemptionsForm do
    initialize_with { new(create(:new_registration, workflow_state: "exemptions_form")) }
  end
end
