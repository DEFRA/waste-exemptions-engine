# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsSummaryForm < BaseForm
    delegate :exemptions,
             :compliance_charge,
             :charge_type,
             :registration_charge,
             :total_charge,
             :band,
             :registration_charge_without_pence,
             to: :exemption_costs_presenter

    def order
      @order ||= create_or_update_order
    end

    def exemption_costs_presenter
      @exemption_costs_presenter ||= WasteExemptionsEngine::ExemptionCostsPresenter.new(order:)
    end

    private

    def create_or_update_order
      WasteExemptionsEngine::CreateOrUpdateOrderService.run(transient_registration: @transient_registration)
    end
  end
end
