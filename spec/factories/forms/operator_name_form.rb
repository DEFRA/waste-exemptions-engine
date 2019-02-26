# frozen_string_literal: true

FactoryBot.define do
  factory :operator_name_form, class: WasteExemptionsEngine::OperatorNameForm do
    initialize_with do
      new(create(:transient_registration, workflow_state: "operator_name_form"))
    end
  end
end
