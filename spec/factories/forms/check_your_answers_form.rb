# frozen_string_literal: true

FactoryBot.define do
  factory :check_your_answers_form, class: WasteExemptionsEngine::CheckYourAnswersForm do
    initialize_with do
      new(create(:new_registration, :complete, workflow_state: "check_your_answers_form"))
    end
  end
end
