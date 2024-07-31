# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionCostsPresenter
    def initialize(order:)
      @order = order
      @order_calculator = WasteExemptionsEngine::OrderCalculatorService.new(order)
    end

    def exemptions
      @order.exemptions.sort_by { |e| e.band.sequence }
    end

    def compliance_charge(exemption)
      if exemption.band == highest_band
        format_currency(exemption.band.initial_compliance_charge.charge_amount_in_pounds)
      elsif exemption.band.additional_compliance_charge.charge_amount.positive?
        format_currency(exemption.band.additional_compliance_charge.charge_amount_in_pounds)
      else
        format_currency(0)
      end
    end

    def charge_type(exemption)
      if exemption.band == highest_band
        I18n.t("waste_exemptions_engine.exemptions_summary_forms.new.full")
      elsif exemption.band.additional_compliance_charge.charge_amount.positive?
        I18n.t("waste_exemptions_engine.exemptions_summary_forms.new.discounted")
      else
        I18n.t("waste_exemptions_engine.exemptions_summary_forms.new.n_a")
      end
    end

    def registration_charge
      format_currency(
        WasteExemptionsEngine::CurrencyConversionService
        .convert_pence_to_pounds(@order_calculator.registration_charge_amount)
      )
    end

    def total_charge
      format_currency(
        WasteExemptionsEngine::CurrencyConversionService
        .convert_pence_to_pounds(@order_calculator.total_charge_amount)
      )
    end

    private

    def highest_band
      @order.highest_band
    end

    def format_currency(amount)
      helpers.number_to_currency(amount, unit: "£")
    end

    def helpers
      ActionController::Base.helpers
    end
  end
end
