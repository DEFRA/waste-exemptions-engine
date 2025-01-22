# frozen_string_literal: true

FactoryBot.define do
  factory :beta_participant, class: "WasteExemptionsEngine::BetaParticipant" do
    reg_number { "MyString" }
    email { "MyString" }
    token { "MyString" }
    invited_at { nil }
    opted_in { nil }
    registration { nil }
  end
end
