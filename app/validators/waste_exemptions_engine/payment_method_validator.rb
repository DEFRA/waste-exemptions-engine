# frozen_string_literal: true

module WasteExemptionsEngine
  class PaymentMethodValidator < BaseValidator
    include CanValidateSelection

    VALID_PAYMENT_TYPES = %w[card bank_transfer].freeze

    def validate_each(record, attribute, value)
      value_is_included?(record, attribute, value, VALID_PAYMENT_TYPES)
    end
  end
end
