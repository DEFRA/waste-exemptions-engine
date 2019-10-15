# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressValidator < BaseValidator
    def validate_each(record, attribute, value)
      return true if value && (value[:uprn].present? || value[:postcode].present?)

      record.errors[attribute] << error_message(record, attribute, "blank")

      false
    end
  end
end
