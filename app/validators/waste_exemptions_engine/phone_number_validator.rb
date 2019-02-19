# frozen_string_literal: true

module WasteExemptionsEngine
  class PhoneNumberValidator < BaseValidator
    include CanValidatePresence
    include CanValidateLength

    def validate_each(record, attribute, value)
      return false unless value_is_present?(record, attribute, value)

      max_length = 15
      return false unless value_is_not_too_long?(record, attribute, value, max_length)

      valid_format?(record, attribute, value)
    end

    private

    def valid_format?(record, attribute, value)
      return true if Phonelib.valid?(value)

      record.errors[attribute] << error_message(record, attribute, "invalid_format")
      false
    end
  end
end
