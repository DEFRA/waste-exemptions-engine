# frozen_string_literal: true

FactoryBot.define do
  factory :multiple_sites_form, class: "WasteExemptionsEngine::MultipleSitesForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "multiple_sites_form"))
    end
  end

  factory :check_your_answers_multiple_sites_form, class: "WasteExemptionsEngine::MultipleSitesForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "multiple_sites_form",
                                            temp_check_your_answers_flow: true))
    end
  end
end
