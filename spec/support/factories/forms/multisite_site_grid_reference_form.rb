# frozen_string_literal: true

FactoryBot.define do
  factory :multisite_site_grid_reference_form, class: "WasteExemptionsEngine::MultisiteSiteGridReferenceForm" do
    trait :charged do
      # no additional setup needed - factory already uses charged registration
    end

    initialize_with do
      new(create(:new_charged_registration,
                 is_multisite_registration: true,
                 workflow_state: "multisite_site_grid_reference_form"))
    end
  end

end
