# frozen_string_literal: true

FactoryBot.define do
  factory :confirm_edit_exemptions_form, class: "WasteExemptionsEngine::ConfirmEditExemptionsForm" do
    # default to a renewing_registration and allow override to a front_office_edit_registration
    transient do
      transient_registration_factory { :renewing_registration }
    end

    initialize_with do
      new(create(transient_registration_factory, workflow_state: "confirm_edit_exemptions_form"))
    end
  end
end
