# frozen_string_literal: true

FactoryBot.define do
  factory :register_in_northern_ireland_form, class: "WasteExemptionsEngine::RegisterInNorthernIrelandForm" do
    initialize_with do
      new(create(:new_registration, workflow_state: "register_in_northern_ireland_form"))
    end
  end
end
