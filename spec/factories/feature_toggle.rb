# frozen_string_literal: true

FactoryBot.define do
  factory :feature_toggle, class: "WasteExemptionsEngine::FeatureToggle" do
    key { "test-feature" }

    active { false }
  end
end
