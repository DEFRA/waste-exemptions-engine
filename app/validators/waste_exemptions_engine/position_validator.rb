# frozen_string_literal: true

module WasteExemptionsEngine
  class PositionValidator < BaseValidator
    include CanValidateLength

    def validate_each(record, attribute, value)
      # Position is an optional field so its immediately valid if it's blank
      return true if value.blank?
      return false unless value_has_no_invalid_characters?(record, attribute, value)

      max_length = 70
      value_is_not_too_long?(record, attribute, value, max_length)
    end

    private

    def value_has_no_invalid_characters?(record, attribute, value)
      # Name fields must contain only letters, spaces, commas, full stops, hyphens and apostrophes
      return true if value.match?(/\A[-a-z\s,.']+\z/i)

      record.errors[attribute] << error_message(record, attribute, "invalid")
      false
    end
  end
end
