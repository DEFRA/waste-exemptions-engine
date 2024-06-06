# frozen_string_literal: true

FactoryBot.define do
  factory :charge_detail, class: "WasteExemptionsEngine::ChargeDetail" do
    registration_charge_amount { Faker::Number.between(from: 6, to: 11) }
    band_charge_details do
      [
        build(:band_charge_detail,
              initial_compliance_charge_amount: Faker::Number.between(from: 7, to: 20),
              additional_compliance_charge_amount: Faker::Number.between(from: 5, to: 10)),
        build(:band_charge_detail,
              initial_compliance_charge_amount: Faker::Number.between(from: 7, to: 20),
              additional_compliance_charge_amount: Faker::Number.between(from: 5, to: 10)),
        build(:band_charge_detail,
              initial_compliance_charge_amount: Faker::Number.between(from: 7, to: 20),
              additional_compliance_charge_amount: Faker::Number.between(from: 5, to: 10))
      ]
    end
  end
end
