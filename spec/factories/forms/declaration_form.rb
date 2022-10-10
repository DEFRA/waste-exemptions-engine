# frozen_string_literal: true

FactoryBot.define do
  factory :declaration_form, class: "WasteExemptionsEngine::DeclarationForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "declaration_form"))
    end
  end
end
