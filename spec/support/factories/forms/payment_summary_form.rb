# frozen_string_literal: true

FactoryBot.define do
  factory :payment_summary_form, class: "WasteExemptionsEngine::PaymentSummaryForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "payment_summary_form"))
    end
  end
end
