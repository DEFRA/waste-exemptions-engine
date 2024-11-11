# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: "WasteExemptionsEngine::Order" do

    trait :with_exemptions do
      exemptions { build_list(:exemption, 3, band: build(:band)) }
    end

    trait :with_bucket do
      association :bucket
    end

    trait :with_charge_detail do
      charge_detail
    end

    trait :with_payment do
      payments do
        [build(:payment, payment_amount: total_charge_amount,
                         payment_status: WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS)]
      end
    end
  end
end
