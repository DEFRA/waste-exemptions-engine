# frozen_string_literal: true

FactoryBot.define do
  factory :cannot_renew_type_change_form, class: "WasteExemptionsEngine::CannotRenewTypeChangeForm" do
    initialize_with do
      new(create(:renewing_registration, workflow_state: "cannot_renew_type_change_form"))
    end
  end
end
