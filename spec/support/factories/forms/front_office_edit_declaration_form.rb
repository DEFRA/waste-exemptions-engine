# frozen_string_literal: true

FactoryBot.define do
  factory :front_office_edit_declaration_form, class: "WasteExemptionsEngine::FrontOfficeEditDeclarationForm" do
    initialize_with do
      new(create(:front_office_edit_registration, workflow_state: "front_office_edit_declaration_form"))
    end
  end
end
