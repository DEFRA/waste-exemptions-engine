# frozen_string_literal: true

FactoryBot.define do
  factory :multisite_exemptions_summary_form, class: "WasteExemptionsEngine::MultisiteExemptionsSummaryForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "multisite_exemptions_summary_form"))
    end
  end

  factory :check_your_answers_multisite_exemptions_summary_form,
          class: "WasteExemptionsEngine::MultisiteExemptionsSummaryForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "multisite_exemptions_summary_form",
                                            temp_check_your_answers_flow: true))
    end
  end
end
