# frozen_string_literal: true

FactoryBot.define do
  factory :confirm_edit_cancelled_form, class: "WasteExemptionsEngine::EditForm" do
    initialize_with do
      new(create(:edit_registration, workflow_state: "confirm_edit_cancelled_form"))
    end
  end
end
