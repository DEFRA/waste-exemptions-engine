# frozen_string_literal: true

FactoryBot.define do
  factory :start_form, class: "WasteExemptionsEngine::StartForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "start_form"))
    end
  end
end
