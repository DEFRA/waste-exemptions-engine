# frozen_string_literal: true

FactoryBot.define do
  factory :bucket, class: "WasteExemptionsEngine::Bucket" do
    sequence(:name) { |n| "Bucket #{n}" }
    initial_compliance_charge { association :charge, :initial_compliance_charge }
    bucket_type { "farmer" }
  end
end
