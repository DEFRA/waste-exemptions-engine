# frozen_string_literal: true

FactoryBot.define do
  factory :back_office_edit_cancelled_form, class: "WasteExemptionsEngine::BackOfficeEditCancelledForm" do
    initialize_with do
      new(create(:edit_registration, workflow_state: "back_office_edit_cancelled_form"))
    end
  end
end
