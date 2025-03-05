# frozen_string_literal: true

FactoryBot.define do
  factory :charity_register_free_form, class: "WasteExemptionsEngine::CharityRegisterFreeForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "charity_register_free_form"))
    end
  end
end
