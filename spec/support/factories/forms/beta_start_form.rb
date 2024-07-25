# frozen_string_literal: true

FactoryBot.define do
  factory :beta_start_form, class: "WasteExemptionsEngine::BetaStartForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "beta_start_form"))
    end
  end
end
