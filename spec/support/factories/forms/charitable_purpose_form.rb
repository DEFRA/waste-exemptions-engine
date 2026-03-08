# frozen_string_literal: true

FactoryBot.define do
  factory :charitable_purpose_form, class: "WasteExemptionsEngine::CharitablePurposeForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "charitable_purpose_form"))
    end
  end

  factory :check_your_answers_edit_charitable_purpose_form, class: "WasteExemptionsEngine::CharitablePurposeForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "charitable_purpose_form", charitable_purpose: true,
                                            temp_check_your_answers_flow: true))
    end
  end
end
