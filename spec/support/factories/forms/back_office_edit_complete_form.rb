# frozen_string_literal: true

FactoryBot.define do
  factory :back_office_edit_complete_form, class: "WasteExemptionsEngine::BackOfficeEditCompleteForm" do
    initialize_with do
      new(create(:back_office_edit_registration, :modified, workflow_state: "back_office_edit_complete_form"))
    end
  end
end
