# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorNameValidator < BaseValidator
    include CanValidatePresence
    include CanValidateLength

    def validate_each(record, attribute, value)
      return false unless value_is_present?(record, attribute, value)

      max_length = 255
      value_is_not_too_long?(record, attribute, value, max_length)
    end
  end
end
