# frozen_string_literal: true

FactoryBot.define do
  factory :edit_exemptions_form, class: "WasteExemptionsEngine::EditExemptionsForm" do
    initialize_with do
      new(create(:front_office_edit_registration, workflow_state: "edit_exemptions_form"))
    end
  end
end
