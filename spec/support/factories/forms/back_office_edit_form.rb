# frozen_string_literal: true

FactoryBot.define do
  factory :back_office_edit_form, class: "WasteExemptionsEngine::BackOfficeEditForm" do
    initialize_with do
      new(create(:edit_registration, workflow_state: "back_office_edit_form"))
    end
  end
end
