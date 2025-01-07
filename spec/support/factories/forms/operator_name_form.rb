# frozen_string_literal: true

FactoryBot.define do
  factory :operator_name_form, class: "WasteExemptionsEngine::OperatorNameForm" do
    model_factory { :new_registration }

    trait :charged do
      model_factory { :new_charged_registration }
    end

    initialize_with do
      new(create(model_factory, :sole_trader, workflow_state: "operator_name_form"))
    end
  end

  factory :edit_operator_name_form, class: "WasteExemptionsEngine::OperatorNameForm" do
    initialize_with do
      new(create(:back_office_edit_registration, workflow_state: "operator_name_form"))
    end
  end

  factory :renew_operator_name_form, class: "WasteExemptionsEngine::OperatorNameForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "operator_name_form"))
    end
  end

  factory :check_your_answers_edit_operator_name_form, class: "WasteExemptionsEngine::OperatorNameForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "operator_name_form", operator_name: "We Operate inc.",
                                    temp_check_your_answers_flow: true))
    end
  end
end
