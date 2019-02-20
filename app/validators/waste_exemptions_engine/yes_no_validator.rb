# frozen_string_literal: true

module WasteExemptionsEngine
  class YesNoValidator < BaseValidator
    include CanValidateSelection

    def validate_each(record, attribute, value)
      valid_options = %w[true false]

      value_is_included?(record, attribute, value, valid_options)
    end
  end
end
