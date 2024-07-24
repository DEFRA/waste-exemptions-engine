# frozen_string_literal: true

FactoryBot.define do
  factory :band_charge_detail, class: "WasteExemptionsEngine::BandChargeDetail" do
    initial_compliance_charge_amount { Faker::Number.between(from: 7, to: 20) }
    additional_compliance_charge_amount { Faker::Number.between(from: 5, to: 10) }
  end
end
