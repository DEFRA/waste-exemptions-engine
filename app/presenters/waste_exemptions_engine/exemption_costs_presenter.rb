# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionCostsPresenter
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

    def compliance_charge(exemption)
      if exemption_in_bucket?(exemption)
        bucket_exemption_compliance_charge
      elsif first_exemption_in_highest_band?(exemption)
        multisite_charge_for_exemption(exemption.band.initial_compliance_charge.charge_amount)
      elsif exemption.band.additional_compliance_charge.charge_amount.positive?
        multisite_charge_for_exemption(exemption.band.additional_compliance_charge.charge_amount)
      else
        format_currency(0)
      end
    end

    def single_site_compliance_charge(exemption)
      # Get the single-site charge without multisite multiplication
      if exemption_in_bucket?(exemption)
        single_site_bucket_exemption_compliance_charge
      elsif first_exemption_in_highest_band?(exemption)
        format_charge_as_currency(exemption.band.initial_compliance_charge)
      elsif exemption.band.additional_compliance_charge.charge_amount.positive?
        format_charge_as_currency(exemption.band.additional_compliance_charge)
      else
        format_currency(0)
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

    def farm_exemptions_selected?
      farmer_bucket_in_order? && @order.exemptions.any? { |e| farmer_bucket_exemption?(e) }
    end

    def farming_exemptions
      @farming_exemptions ||= exemptions.select { |e| farmer_bucket_exemption?(e) }
    end

    def non_farming_exemptions
      @non_farming_exemptions ||= exemptions.reject { |e| farmer_bucket_exemption?(e) }
    end

    def farming_exemptions_codes
      farming_exemptions.map(&:code).join(", ")
    end

    def farming_exemptions_charge
      return format_currency(0) if farming_exemptions.empty?

      first_farming_exemption = farming_exemptions.first
      compliance_charge(first_farming_exemption)
    end

    def farming_exemptions_single_site_charge
      return format_currency(0) if farming_exemptions.empty?

      first_farming_exemption = farming_exemptions.first
      single_site_compliance_charge(first_farming_exemption)
    end

    def exemption_title_with_band(exemption)
      band_name = exemption.band&.name
      return "#{exemption.code} #{exemption.summary.capitalize}" unless band_name.present?

      "#{exemption.code} #{exemption.summary.capitalize} (#{band_name.downcase})"
    end

    def is_discounted_charge?(exemption)
      return false if exemption_in_bucket?(exemption)
      return false if first_exemption_in_highest_band?(exemption)
      
      exemption.band.additional_compliance_charge.charge_amount.positive?
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

    def bucket_exemption_compliance_charge
      format_currency(
        WasteExemptionsEngine::CurrencyConversionService
        .convert_pence_to_pounds(@order_calculator.bucket_charge_amount)
      )
    end

    def single_site_bucket_exemption_compliance_charge
      format_currency(
        WasteExemptionsEngine::CurrencyConversionService
        .convert_pence_to_pounds(@order_calculator.base_bucket_charge_amount)
      )
    end

    def multisite_charge_for_exemption(base_charge_amount)
      # Apply multisite multiplication if this is a multisite registration
      site_count = @order.order_owner&.is_multisite_registration ? @order.order_owner.site_count : 1

      format_currency(
        WasteExemptionsEngine::CurrencyConversionService
        .convert_pence_to_pounds(base_charge_amount * site_count)
      )
    end

  end
end
