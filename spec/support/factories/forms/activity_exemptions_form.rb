# frozen_string_literal: true

FactoryBot.define do
  factory :activity_exemptions_form, class: "WasteExemptionsEngine::ActivityExemptionsForm" do
    initialize_with { new(create(:new_charged_registration, workflow_state: "activity_exemptions_form")) }
  end

  factory :new_charged_registration_flow_activity_exemptions_form,
          class: "WasteExemptionsEngine::ActivityExemptionsForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "activity_exemptions_form"))
    end
  end
end
