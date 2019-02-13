# frozen_string_literal: true

module WasteExemptionsEngine
  class BusinessTypeValidator < BaseValidator
    def validate_each(record, attribute, value)
      valid_business_type?(record, attribute, value)
    end

    private

    def valid_business_type?(record, attribute, value)
      valid_business_types = %w[charity
                                limitedCompany
                                limitedLiabilityPartnership
                                localAuthority
                                partnership
                                soleTrader]

      return true if value.present? && valid_business_types.include?(value)

      record.errors[attribute] << error_message(record, attribute, "inclusion")
      false
    end
  end
end
