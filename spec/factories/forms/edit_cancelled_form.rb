# frozen_string_literal: true

FactoryBot.define do
  factory :edit_cancelled_form, class: WasteExemptionsEngine::EditCancelledForm do
    initialize_with do
      new(create(:edit_registration, workflow_state: "edit_cancelled_form"))
    end
  end
end
