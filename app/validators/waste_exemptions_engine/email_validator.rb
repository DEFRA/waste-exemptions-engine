# frozen_string_literal: true

require "validates_email_format_of"

module WasteExemptionsEngine
  class EmailValidator < BaseValidator
    include CanValidatePresence

    def validate_each(record, attribute, value)
      return false unless value_is_present?(record, attribute, value)

      valid_format?(record, attribute, value)
    end

    private

    def valid_format?(record, attribute, value)
      # validate_email_format returns nil if the validation passes
      return true unless ValidatesEmailFormatOf.validate_email_format(value)

      record.errors[attribute] << error_message(record, attribute, "invalid_format")
      false
    end
  end
end
