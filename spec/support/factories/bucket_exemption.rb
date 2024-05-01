# frozen_string_literal: true

FactoryBot.define do
  factory :bucket_exemption, class: "WasteExemptionsEngine::BucketExemption" do
    bucket
    exemption
  end
end
