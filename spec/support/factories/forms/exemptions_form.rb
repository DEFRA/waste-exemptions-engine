# frozen_string_literal: true

FactoryBot.define do
  factory :exemptions_form, class: "WasteExemptionsEngine::ExemptionsForm" do
    initialize_with { new(create(:new_registration, workflow_state: "exemptions_form")) }
  end

  factory :check_your_answers_edit_exemptions_form, class: "WasteExemptionsEngine::ExemptionsForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "exemptions_form",
                                    exemption_ids: WasteExemptionsEngine::Exemption.limit(5).pluck(:id),
                                    temp_check_your_answers_flow: true))
    end
  end

  factory :renewal_start_edit_exemptions_form, class: "WasteExemptionsEngine::ExemptionsForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "exemptions_form",
                                         exemption_ids: WasteExemptionsEngine::Exemption.limit(5).pluck(:id),
                                         temp_check_your_answers_flow: true))
    end
  end

  factory :new_charged_registration_flow_exemptions_form, class: "WasteExemptionsEngine::ExemptionsForm" do
    initialize_with do
      new(create(:new_charged_registration, workflow_state: "exemptions_form"))
    end
  end
end
