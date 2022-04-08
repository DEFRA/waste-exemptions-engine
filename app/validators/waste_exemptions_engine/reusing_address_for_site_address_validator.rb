# frozen_string_literal: true

module WasteExemptionsEngine
  class ReusingAddressForSiteAddressValidator < BaseValidator
    include CanValidateSelection

    def validate_each(record, attribute, value)
      valid_values = %w[operator_address_option
                        contact_address_option
                        a_different_address]
      return true if valid_values.include?(value)

      add_validation_error(record, attribute, :inclusion)
      false
    end
  end
end
