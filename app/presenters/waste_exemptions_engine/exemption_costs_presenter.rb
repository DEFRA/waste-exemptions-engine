# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionCostsPresenter
    NOT_APPLICABLE_TRANSLATION_KEY = "waste_exemptions_engine.exemptions_summary_forms.new.n_a"

    include CanSortExemptions

    attr_accessor :order

    def initialize(order:)
      @order = order
      @order_calculator = WasteExemptionsEngine::OrderCalculatorService.new(order)
    end

    def exemptions
      # Show farm exemptions first, then sort the rest by compliance charge amount
      @exemptions ||= begin
        all_exemptions = @order.exemptions
        farm_exemptions = all_exemptions.select { |e| farmer_bucket_exemption?(e) }
        non_farm_exemptions = all_exemptions.reject { |e| farmer_bucket_exemption?(e) }

        sorted_farm_exemptions = sorted_exemptions(farm_exemptions)
        sorted_non_farm_exemptions = non_farm_exemptions.sort_by do |e|
          [-e.band.initial_compliance_charge.charge_amount, e.code]
        end

        sorted_farm_exemptions + sorted_non_farm_exemptions
      end
    end

    def band(exemption)
      if exemption_in_bucket?(exemption)
        I18n.t(NOT_APPLICABLE_TRANSLATION_KEY)
      else
        exemption.band&.sequence || I18n.t(NOT_APPLICABLE_TRANSLATION_KEY)
      end
    end

    def compliance_charge(exemption)
      if exemption_in_bucket?(exemption)
        bucket_exemption_compliance_charge(exemption).presence ||
          I18n.t(NOT_APPLICABLE_TRANSLATION_KEY)
      elsif first_exemption_in_highest_band?(exemption)
        format_charge_as_currency(exemption.band.initial_compliance_charge)
      elsif exemption.band.additional_compliance_charge.charge_amount.positive?
        format_charge_as_currency(exemption.band.additional_compliance_charge)
      else
        format_currency(0)
      end
    end

    def charge_type(exemption)
      if exemption.band.additional_compliance_charge.charge_amount.zero?
        I18n.t(NOT_APPLICABLE_TRANSLATION_KEY)
      elsif farmer_bucket_exemption?(exemption)
        I18n.t("waste_exemptions_engine.exemptions_summary_forms.new.farm")
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

    def total_compliance_charge
      format_currency(
        WasteExemptionsEngine::CurrencyConversionService
        .convert_pence_to_pounds(@order_calculator.total_compliance_charge_amount)
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

    def format_charge_as_currency(charge)
      format_currency(charge.charge_amount_in_pounds)
    end

    def helpers
      ActionController::Base.helpers
    end

    def first_exemption_in_highest_band?(exemption)
      return false if exemption_in_bucket?(exemption)

      non_bucket_exemptions = exemptions.reject { |e| exemption_in_bucket?(e) }
      exemption.band == highest_band && exemption == non_bucket_exemptions.first
    end

    def farmer_bucket_in_order?
      order.bucket == Bucket.farmer_bucket
    end

    def farmer_bucket_exemption?(exemption)
      farmer_bucket_in_order? && Bucket.farmer_bucket&.exemptions&.include?(exemption)
    end

    def exemption_in_bucket?(exemption)
      order.bucket.present? && order.bucket.exemptions.include?(exemption)
    end

    def first_bucket_exemption_in_order?(exemption)
      bucket_exemptions = order.bucket&.exemptions&.to_a
      return false if bucket_exemptions.empty?

      bucket_exemptions_in_order = bucket_exemptions.intersection(order.exemptions)
      return false if bucket_exemptions_in_order.empty?

      exemption == sorted_exemptions(bucket_exemptions_in_order).first
    end

    def bucket_exemption_compliance_charge(exemption)
      if first_bucket_exemption_in_order?(exemption)
        format_currency(
          WasteExemptionsEngine::CurrencyConversionService
          .convert_pence_to_pounds(@order_calculator.bucket_charge_amount)
        )
      else
        I18n.t(NOT_APPLICABLE_TRANSLATION_KEY)
      end
    end
  end
end
