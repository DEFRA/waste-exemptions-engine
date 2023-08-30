# frozen_string_literal: true

FactoryBot.define do
  factory :confirm_edit_exemptions_form, class: "WasteExemptionsEngine::ConfirmEditExemptionsForm" do
    # default to a renewing_registration and allow override to a front_office_edit_registration
    transient do
      front_office { false }
    end

    initialize_with do
      factory = front_office ? :front_office_edit_registration : :renewing_registration
      new(create(factory, workflow_state: "confirm_edit_exemptions_form"))
    end
  end
end
