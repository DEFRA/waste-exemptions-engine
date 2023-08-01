# frozen_string_literal: true

FactoryBot.define do
  factory :capture_reference_form, class: "WasteExemptionsEngine::CaptureReferenceForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "capture_reference_form"))
    end
  end
end
