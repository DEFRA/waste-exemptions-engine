# frozen_string_literal: true

FactoryBot.define do
  factory :front_office_edit_complete_form, class: "WasteExemptionsEngine::FrontOfficeEditCompleteForm" do
    initialize_with do
      new(create(:front_office_edit_registration, :modified, workflow_state: "front_office_edit_complete_form"))
    end
  end
end
