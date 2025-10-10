# frozen_string_literal: true

FactoryBot.define do
  factory :sites_form, class: "WasteExemptionsEngine::SitesForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "sites_form"))
    end
  end

  factory :check_your_answers_sites_form, class: "WasteExemptionsEngine::SitesForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "sites_form",
                                            temp_check_your_answers_flow: true))
    end
  end
end
