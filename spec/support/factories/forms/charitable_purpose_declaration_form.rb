# frozen_string_literal: true

FactoryBot.define do
  factory :charitable_purpose_declaration_form, class: "WasteExemptionsEngine::CharitablePurposeDeclarationForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "charitable_purpose_declaration_form"))
    end
  end
end
