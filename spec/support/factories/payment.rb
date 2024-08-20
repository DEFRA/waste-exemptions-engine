# frozen_string_literal: true

FactoryBot.define do
  factory :payment, class: "WasteExemptionsEngine::Payment" do
    payment_type { "govpay_payment" }
    payment_amount { 1000 }
    payment_status { "created" }
    order
  end
end
