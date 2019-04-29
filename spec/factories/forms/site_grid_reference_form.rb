# frozen_string_literal: true

FactoryBot.define do
  factory :site_grid_reference_form, class: WasteExemptionsEngine::SiteGridReferenceForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "site_grid_reference_form"))
    end
  end
end
