# frozen_string_literal: true

FactoryBot.define do
  factory :operation_sites_form, class: "WasteExemptionsEngine::OperationSitesForm" do
    initialize_with do
      new(create(:back_office_edit_registration, workflow_state: "operation_sites_form"))
    end
  end
end
