# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressValidator < BaseValidator
    include CanValidatePresence

    def validate_each(record, attribute, value)
      value_is_present?(record, attribute, value)
    end
  end
end
