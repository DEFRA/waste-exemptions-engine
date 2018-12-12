# frozen_string_literal: true

module WasteExemptionsEngine
  class TokenValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return false unless value_is_present?(record, attribute, value)

      valid_format?(record, attribute, value)
    end

    private

    def value_is_present?(record, attribute, value)
      return true if value.present?

      record.errors[attribute] << error_message(record, attribute, "missing")
      false
    end

    def valid_format?(record, attribute, value)
      # Make sure the token is present
      return true if value.length == 24

      record.errors[attribute] << error_message(record, attribute, "invalid_format")
      false
    end

    def error_message(record, attribute, error)
      class_name = record.class.to_s.underscore
      I18n.t("activemodel.errors.models.#{class_name}.attributes.#{attribute}.#{error}")
    end
  end
end
