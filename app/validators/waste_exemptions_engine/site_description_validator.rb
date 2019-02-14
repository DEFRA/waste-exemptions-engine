# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteDescriptionValidator < BaseValidator
    include CanValidatePresence
    include CanValidateLength

    def validate_each(record, attribute, value)
      return false unless value_is_present?(record, attribute, value)

      macx_length = 500
      value_is_not_too_long?(record, attribute, value, macx_length)
    end
  end
end
