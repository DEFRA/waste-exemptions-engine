# frozen_string_literal: true

module WasteExemptionsEngine
  class ReusingAddressForSiteAddressValidator < BaseValidator
    include CanValidateSelection

    def validate_each(record, attribute, value)
      valid_options = %w[operator_address_option
                         contact_address_option
                         a_different_address]

      value_is_included?(record, attribute, value, valid_options)
    end
  end
end
