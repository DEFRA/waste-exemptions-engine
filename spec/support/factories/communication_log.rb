# frozen_string_literal: true

FactoryBot.define do
  factory :communication_log, class: "WasteExemptionsEngine::CommunicationLog" do
    message_type { %w[letter email text].sample }
    template_id { SecureRandom.hex(12) }
    template_label { Faker::Lorem.word }
  end
end
