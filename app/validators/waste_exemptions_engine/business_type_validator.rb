# frozen_string_literal: true

module WasteExemptionsEngine
  class BusinessTypeValidator < BaseValidator
    include CanValidateSelection

    def validate_each(record, attribute, value)
      valid_business_types = TransientRegistration::BUSINESS_TYPES.values

      value_is_included?(record, attribute, value, valid_business_types)
    end
  end
end
