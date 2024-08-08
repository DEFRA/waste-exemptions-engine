# frozen_string_literal: true

module WasteExemptionsEngine
  class PaymentSummaryForm < BaseForm
    delegate :payment_type, :order, to: :transient_registration
    delegate :total_compliance_charge, :registration_charge, :total_charge, to: :exemption_costs_presenter

    validates :payment_type, "waste_exemptions_engine/payment_type": true

    def exemption_costs_presenter
      @exemption_costs_presenter ||= WasteExemptionsEngine::ExemptionCostsPresenter.new(order: order)
    end

    private

    def payment_type_card?
      payment_type == "card"
    end
  end
end
