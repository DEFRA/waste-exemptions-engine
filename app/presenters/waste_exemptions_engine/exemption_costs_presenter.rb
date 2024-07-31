# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionCostsPresenter
    def initialize(order:)
      @order = order
      @order_calculator = WasteExemptionsEngine::OrderCalculatorService.new(order)
    end

    def exemptions
      @exemptions ||= @order.exemptions.sort_by { |e| -e.band.initial_compliance_charge.charge_amount }
    end

    def compliance_charge(exemption)
      if first_exemption_in_highest_band?(exemption)
        format_currency(exemption.band.initial_compliance_charge.charge_amount_in_pounds)
      elsif exemption.band.additional_compliance_charge.charge_amount.positive?
        format_currency(exemption.band.additional_compliance_charge.charge_amount_in_pounds)
      else
        format_currency(0)
      end
    end

    def charge_type(exemption)
      if exemption.band.additional_compliance_charge.charge_amount.zero?
        I18n.t("waste_exemptions_engine.exemptions_summary_forms.new.n_a")
      elsif first_exemption_in_highest_band?(exemption)
        I18n.t("waste_exemptions_engine.exemptions_summary_forms.new.full")
      else
        I18n.t("waste_exemptions_engine.exemptions_summary_forms.new.discounted")
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
      @highest_band ||= @order.highest_band
    end

    def format_currency(amount)
      helpers.number_to_currency(amount, unit: "£")
    end

    def helpers
      ActionController::Base.helpers
    end

    def first_exemption_in_highest_band?(exemption)
      exemption.band == highest_band && exemption == exemptions.first
    end
  end
end
