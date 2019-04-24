# frozen_string_literal: true

FactoryBot.define do
  factory :contact_position_form, class: WasteExemptionsEngine::ContactPositionForm do
    initialize_with do
      new(create(:new_registration, workflow_state: "contact_position_form"))
    end
  end
end
