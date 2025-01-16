# frozen_string_literal: true

FactoryBot.define do
  factory :farm_exemptions_form, class: "WasteExemptionsEngine::FarmExemptionsForm" do
    trait :charged do
      # currently farm_exemptions_form is available for charged registrations only,
      # so factory gets initialised with charged registration by default
      # no need to do anything here.
    end

    initialize_with { new(create(:new_charged_registration, workflow_state: "farm_exemptions_form")) }
  end
end
