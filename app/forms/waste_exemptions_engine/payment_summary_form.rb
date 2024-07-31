# frozen_string_literal: true

module WasteExemptionsEngine
  class PaymentSummaryForm < BaseForm
    delegate :payment_type, :order, to: :transient_registration
    delegate :total_compliance_charge, :registration_charge, :total_charge, to: :exemption_costs_presenter

    def exemption_costs_presenter
      @exemption_costs_presenter ||= WasteExemptionsEngine::ExemptionCostsPresenter.new(order: order)
    end
  end
end
