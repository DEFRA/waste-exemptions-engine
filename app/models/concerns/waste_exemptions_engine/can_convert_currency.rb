# frozen_string_literal: true

# app/models/concerns/waste_exemptions_engine/can_convert_currency.rb

module WasteExemptionsEngine
  module CanConvertCurrency
    extend ActiveSupport::Concern

    class_methods do
      def convert_pence_to_pounds(pence, hide_pence_if_zero: false)
        pounds = pence.to_f / 100
        format_pounds(pounds, hide_pence_if_zero)
      end

      def convert_pounds_to_pence(pounds)
        (pounds.to_f * 100).round
      end

      private

      def format_pounds(pounds, hide_pence_if_zero)
        if hide_pence_if_zero && pounds.round(2) == pounds.to_i
          format("£%.0f", pounds)
        else
          format("£%.2f", pounds)
        end
      end
    end

    # Instance methods
    def convert_pence_to_pounds(pence, hide_pence_if_zero: false)
      self.class.convert_pence_to_pounds(pence, hide_pence_if_zero: hide_pence_if_zero)
    end

    def convert_pounds_to_pence(pounds)
      self.class.convert_pounds_to_pence(pounds)
    end
  end
end
