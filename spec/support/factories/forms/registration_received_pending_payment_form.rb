# frozen_string_literal: true

FactoryBot.define do
  factory :registration_received_pending_payment_form,
          class: "WasteExemptionsEngine::RegistrationReceivedPendingPaymentForm" do

    initialize_with do
      new(create(:new_charged_registration, :complete, :with_active_exemptions,
                 workflow_state: "registration_received_pending_payment_form").tap(&:create_order))
    end
  end
end
