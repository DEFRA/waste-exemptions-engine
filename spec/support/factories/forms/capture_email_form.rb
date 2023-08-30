# frozen_string_literal: true

FactoryBot.define do
  factory :capture_email_form, class: "WasteExemptionsEngine::CaptureEmailForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "capture_email_form"))
    end
  end
end
