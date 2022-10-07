# frozen_string_literal: true

FactoryBot.define do
  factory :registration_exemption, class: "WasteExemptionsEngine::RegistrationExemption" do
    expires_on { 3.years.from_now }
    registered_on { Date.today }

    exemption

    state { :active }

    trait :past_renewal_window do
      expires_on { 3.months.ago }
      state { :expired }
    end
  end
end
