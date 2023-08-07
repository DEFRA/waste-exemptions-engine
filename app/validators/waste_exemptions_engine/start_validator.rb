# frozen_string_literal: true

module WasteExemptionsEngine
  class StartValidator < BaseValidator
    include CanValidateSelection

    def validate_each(record, attribute, value)
      valid_options = %w[new
                         reregister
                         edit]

      value_is_included?(record, attribute, value, valid_options)
    end
  end
end
