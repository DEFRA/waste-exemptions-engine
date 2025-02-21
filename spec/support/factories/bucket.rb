# frozen_string_literal: true

FactoryBot.define do
  factory :bucket, class: "WasteExemptionsEngine::Bucket" do
    name { "Bucket #{Faker::Lorem.unique.word}" }
    initial_compliance_charge { association :charge, :initial_compliance_charge }
    bucket_type { "farmer" }
    exemptions { create_list(:exemption, 4) }
  end
end
