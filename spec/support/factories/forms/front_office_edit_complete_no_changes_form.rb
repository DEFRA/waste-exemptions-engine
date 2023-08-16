# frozen_string_literal: true

FactoryBot.define do
  factory :front_office_edit_complete_no_changes_form,
          class: "WasteExemptionsEngine::FrontOfficeEditCompleteNoChangesForm" do

    initialize_with do
      new(create(:front_office_edit_registration, workflow_state: "front_office_edit_complete_no_changes_form"))
    end
  end
end
