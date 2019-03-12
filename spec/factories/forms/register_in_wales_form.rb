# frozen_string_literal: true

FactoryBot.define do
  factory :register_in_wales_form, class: WasteExemptionsEngine::RegisterInWalesForm do
    initialize_with do
      new(create(:transient_registration, workflow_state: "register_in_wales_form"))
    end
  end
end
