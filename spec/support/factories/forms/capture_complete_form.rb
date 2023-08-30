# frozen_string_literal: true

FactoryBot.define do
  factory :capture_complete_form, class: "WasteExemptionsEngine::CaptureCompleteForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "capture_complete_form"))
    end
  end
end
