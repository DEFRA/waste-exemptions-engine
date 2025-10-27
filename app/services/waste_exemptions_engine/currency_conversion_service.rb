# frozen_string_literal: true

module WasteExemptionsEngine
  class CurrencyConversionService
    def self.convert_pence_to_pounds(pence, hide_pence_if_zero: false)
      pounds = pence.to_f / 100
      pence_is_zero = (pounds % 1).zero?
      precision = hide_pence_if_zero && pence_is_zero ? 0 : 2

      ActionController::Base.helpers.number_to_currency(
        pounds,
        unit: "",
        precision: precision
      ).strip
    end

    def self.convert_pounds_to_pence(pounds)
      (pounds.to_f * 100).round
    end
  end
end
