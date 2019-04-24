# frozen_string_literal: true

FactoryBot.define do
  factory :edit_registration, class: WasteExemptionsEngine::EditRegistration do
    # Create a new registration when initializing so we can copy its data
    initialize_with do
      new(reference: create(:registration, :complete).reference)
    end
  end
end
