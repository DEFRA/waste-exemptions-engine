# frozen_string_literal: true

FactoryBot.define do
  factory :confirm_back_office_edit_cancelled_form, class: "WasteExemptionsEngine::BackOfficeEditForm" do
    initialize_with do
      new(create(:back_office_edit_registration, workflow_state: "confirm_back_office_edit_cancelled_form"))
    end
  end
end
