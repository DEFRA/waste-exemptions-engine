# frozen_string_literal: true

FactoryBot.define do
  factory :renewal_stop_form, class: "WasteExemptionsEngine::RenewalStopForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "renewal_stop_form"))
    end
  end
end
