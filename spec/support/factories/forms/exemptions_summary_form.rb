# frozen_string_literal: true

FactoryBot.define do
  factory :exemptions_summary_form, class: "WasteExemptionsEngine::ExemptionsSummaryForm" do
    initialize_with { new(create(:new_charged_registration, workflow_state: "exemptions_summary_form")) }
  end

  factory :check_your_answers_exemptions_summary_form, class: "WasteExemptionsEngine::ExemptionsSummaryForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "exemptions_summary_form",
                                            temp_check_your_answers_flow: true))
    end
  end
end
