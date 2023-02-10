# frozen_string_literal: true

FactoryBot.define do
  factory :edit_exemptions_declaration_form, class: "WasteExemptionsEngine::EditExemptionsDeclarationForm" do
    initialize_with { new(create(:renewing_registration, workflow_state: "edit_exemptions_declaration_form")) }
  end
end
