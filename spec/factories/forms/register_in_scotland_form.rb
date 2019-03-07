# frozen_string_literal: true

FactoryBot.define do
  factory :register_in_scotland_form, class: WasteExemptionsEngine::RegisterInScotlandForm do
    initialize_with do
      new(create(:transient_registration, workflow_state: "register_in_scotland_form"))
    end
  end
end
