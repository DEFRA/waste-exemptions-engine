# frozen_string_literal: true

FactoryBot.define do
  factory :edit_confirm_cancel_form, class: WasteExemptionsEngine::EditForm do
    initialize_with do
      new(create(:edit_registration, workflow_state: "edit_confirm_cancel_form"))
    end
  end
end
