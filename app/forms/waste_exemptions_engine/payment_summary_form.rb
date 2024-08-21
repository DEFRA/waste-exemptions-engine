# frozen_string_literal: true

module WasteExemptionsEngine
  class PaymentSummaryForm < BaseForm
    delegate :temp_payment_method, :order, to: :transient_registration
    delegate :total_compliance_charge, :registration_charge, :total_charge, to: :exemption_costs_presenter

    validates :temp_payment_method, "waste_exemptions_engine/payment_method": true

    def exemption_costs_presenter
      @exemption_costs_presenter ||= WasteExemptionsEngine::ExemptionCostsPresenter.new(order: order)
    end
  end
end
