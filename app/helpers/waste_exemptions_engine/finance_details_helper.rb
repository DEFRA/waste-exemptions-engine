# frozen_string_literal: true

module WasteExemptionsEngine
  module FinanceDetailsHelper
    include WasteExemptionsEngine::CanConvertCurrency

    def display_pence_as_pounds_and_cents(pence, hide_pence_if_zero: false)
      convert_pence_to_pounds(pence, hide_pence_if_zero: hide_pence_if_zero)
    end
  end
end
