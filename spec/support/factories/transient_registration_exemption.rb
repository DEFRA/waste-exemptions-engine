# frozen_string_literal: true

FactoryBot.define do
  factory :transient_registration_exemption, class: "WasteExemptionsEngine::TransientRegistrationExemption" do
    trait :expires_on do
      expires_on { 3.years.from_now }
    end

    trait :registered_on do
      registered_on { Date.today }
    end
  end
end
