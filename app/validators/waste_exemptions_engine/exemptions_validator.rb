# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsValidator < BaseValidator
    def validate_each(record, attribute, value)
      return true if value.present? && value.length.positive?

      record.errors[attribute] << error_message(record, attribute, "inclusion")
      false
    end
  end
end
