# frozen_string_literal: true

FactoryBot.define do
  factory :edit_complete_form, class: WasteExemptionsEngine::EditCompleteForm do
    initialize_with do
      new(create(:edit_registration, workflow_state: "edit_complete_form"))
    end
  end
end
