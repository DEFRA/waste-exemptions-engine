# frozen_string_literal: true

FactoryBot.define do
  factory :exemptions_summary_form, class: "WasteExemptionsEngine::ExemptionsSummaryForm" do
    initialize_with { new(create(:new_registration, workflow_state: "exemptions_summary_form")) }
  end
end
