# frozen_string_literal: true

FactoryBot.define do
  factory :registration_exemption, class: WasteExemptionsEngine::RegistrationExemption do
    expires_on { 3.years.from_now }

    exemption

    state { :active }

    trait :too_late_to_renew do
      expires_on { 3.months.ago }
      state { :expired }
    end
  end
end
