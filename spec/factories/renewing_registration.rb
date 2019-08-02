# frozen_string_literal: true

FactoryBot.define do
  factory :renewing_registration, class: WasteExemptionsEngine::RenewingRegistration do
    # Create a new registration when initializing so we can copy its data
    initialize_with do
      new(reference: create(:registration, :complete).reference)
    end

    factory :renewing_registration_without_changes do
      temp_renew_without_changes { true }
    end
  end
end
