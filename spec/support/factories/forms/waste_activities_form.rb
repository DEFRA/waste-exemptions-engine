# frozen_string_literal: true

FactoryBot.define do
  factory :waste_activities_form, class: "WasteExemptionsEngine::WasteActivitiesForm" do
    initialize_with { new(create(:new_charged_registration, workflow_state: "waste_activities_form")) }
  end

  factory :new_charged_registration_flow_waste_activities_form, class: "WasteExemptionsEngine::WasteActivitiesForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "waste_activities_form"))
    end
  end
end
