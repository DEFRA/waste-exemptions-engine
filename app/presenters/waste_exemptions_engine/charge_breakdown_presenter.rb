# frozen_string_literal: true

module WasteExemptionsEngine
  class ChargeBreakdownPresenter
    def initialize(registration:)
      @registration = registration
    end

    def breakdown
      lines = registration.account.orders.flat_map { |order| order_breakdown(order) }
      lines.concat(adjustment_lines)
      lines.join("\n")
    end

    private

    attr_reader :registration

    def order_breakdown(order)
      breakdown = OrderChargeBreakdown.new(order:)
      lines = exemption_lines(breakdown)
      lines << "* #{translate(:registration_charge)}: #{format_charge(breakdown.registration_charge_amount)}"
      lines << "* #{translate(:vat_exempt)}: £0"
    end

    def exemption_lines(breakdown)
      lines = []

      if breakdown.bucket_exemptions.any?
        codes = breakdown.bucket_exemptions.map(&:code).join(", ")
        lines << "* #{translate(:farming_exemptions)} (#{codes}): #{format_charge(breakdown.bucket_charge_amount)}"
      end

      breakdown.exemption_charges.each do |item|
        exemption = item.exemption
        charge = format_charge(item.amount_pence)
        lines << "* #{exemption.code} #{exemption.summary.capitalize}: #{charge}"
      end

      lines
    end

    def adjustment_lines
      adjustments = registration.account.charge_adjustments

      [
        adjustment_line(adjustments.select(&:increase?), :additional_charges),
        adjustment_line(adjustments.select(&:decrease?), :reductions_in_charges, negative: true)
      ].compact
    end

    def adjustment_line(adjustments, label, negative: false)
      return if adjustments.empty?

      charge = format_charge(adjustments.sum(&:amount))
      charge = "-#{charge}" if negative
      "* #{translate(label)}: #{charge}"
    end

    def format_charge(amount)
      "£#{CurrencyConversionService.convert_pence_to_pounds(amount)}"
    end

    def translate(key)
      I18n.t(key, scope: "waste_exemptions_engine.charge_breakdown")
    end
  end
end
