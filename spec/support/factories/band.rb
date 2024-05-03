# frozen_string_literal: true

FactoryBot.define do
  factory :band, class: "WasteExemptionsEngine::Band" do
    name { "Band #{Faker::Lorem.unique.word}" }
    sequence(:sequence) { Faker::Number.unique.between(from: 1, to: 99) } # reserved word

    initial_compliance_charge { create(:charge, :initial_compliance_charge) }
    additional_compliance_charge { create(:charge, :additional_compliance_charge) }
  end
end
