# frozen_string_literal: true

module WasteExemptionsEngine
  class CurrencyConversionService
    def self.convert_pence_to_pounds(pence, hide_pence_if_zero: false, return_float: false)
      pounds = pence.to_f / 100
      return pounds if return_float

      format_pounds(pounds, hide_pence_if_zero)
    end

    def self.convert_pounds_to_pence(pounds)
      (pounds.to_f * 100).round
    end

    def self.format_pounds(pounds, hide_pence_if_zero)
      if hide_pence_if_zero && pounds.round(2) == pounds.to_i
        format("%.0f", pounds)
      else
        format("%.2f", pounds)
      end
    end
  end
end
