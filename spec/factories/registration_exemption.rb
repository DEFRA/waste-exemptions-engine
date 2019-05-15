# frozen_string_literal: true

FactoryBot.define do
  factory :registration_exemption, class: WasteExemptionsEngine::RegistrationExemption do
    expires_on { 3.years.from_now }
    state { :active }

    exemption
  end
end
