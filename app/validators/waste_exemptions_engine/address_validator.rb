# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressValidator < BaseValidator
    include ValidatesPresence

    def validate_each(record, attribute, value)
      return false unless value_is_present?(record, attribute, value)

      false
    end
  end
end
