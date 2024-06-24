# frozen_string_literal: true

module WasteExemptionsEngine
  class PaymentSummaryForm < BaseForm
    delegate :payment_type, to: :transient_registration
  end
end
