# frozen_string_literal: true

module WasteExemptionsEngine
  module FinanceDetailsHelper
    def display_pence_as_pounds_and_cents(pence, hide_pence_if_zero: false)
      pounds = pence.to_f / 100

      if (pounds % 1).zero?
        hide_pence_if_zero ? format("%<pounds>.2f", pounds: pounds) : format("%<pounds>.0f", pounds: pounds)
      else
        format("%<pounds>.2f", pounds: pounds)
      end
    end
  end
end
