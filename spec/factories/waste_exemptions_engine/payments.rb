FactoryBot.define do
  factory :payment do
    payment_type { "MyString" }
    payment_amount { 1 }
    payment_status { "MyString" }
    order { nil }
    date_time { "2024-08-15 12:04:24" }
    govpay_id { "MyString" }
    refunded_payment_govpay_id { "MyString" }
    moto_payment { false }
  end
end
