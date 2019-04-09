# frozen_string_literal: true

FactoryBot.define do
  factory :edited_registration, class: WasteExemptionsEngine::EditedRegistration do
    # Create a new registration when initializing so we can copy its data
    initialize_with do
      # Reload the registration so we can get the reference
      new(reference: create(:registration, :complete).reference)
    end
  end
end
