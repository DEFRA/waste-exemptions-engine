# frozen_string_literal: true

module WasteExemptionsEngine
  class TokenValidator < BaseValidator
    include CanValidatePresence

    def validate_each(record, attribute, value)
      return false unless value_is_present?(record, attribute, value)

      valid_format?(record, attribute, value)
    end

    private

    def valid_format?(record, attribute, value)
      # Make sure the token is present
      return true if value.length == 24

      record.errors[attribute] << error_message(record, attribute, "invalid_format")
      false
    end
  end
end
