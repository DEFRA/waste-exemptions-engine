# frozen_string_literal: true

FactoryBot.define do
  factory :multisite_site_grid_reference_form, class: "WasteExemptionsEngine::MultisiteSiteGridReferenceForm" do
    initialize_with do
      new(create(:new_charged_registration,
                 is_multisite_registration: true,
                 workflow_state: "multisite_site_grid_reference_form"))
    end

    trait :charged do
      # no additional setup needed - factory already uses charged registration
    end
  end

  factory :check_your_answers_multisite_site_grid_reference_form,
          class: "WasteExemptionsEngine::MultisiteSiteGridReferenceForm" do
    initialize_with do
      new(create(:new_charged_registration,
                 is_multisite_registration: true,
                 workflow_state: "multisite_site_grid_reference_form",
                 temp_check_your_answers_flow: true))
    end
  end
end
