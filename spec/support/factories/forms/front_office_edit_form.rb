# frozen_string_literal: true

FactoryBot.define do
  factory :front_office_edit_form, class: "WasteExemptionsEngine::FrontOfficeEditForm" do
    initialize_with do
      new(create(:front_office_edit_registration, workflow_state: "front_office_edit_form"))
    end
  end
end
