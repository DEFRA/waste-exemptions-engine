# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return false unless value_is_present?(record, attribute, value)

      valid_uk_address?(record, attribute, value)
    end

    private

    def value_is_present?(record, attribute, value)
      return true if value.present?

      record.errors[attribute] << error_message(record, attribute, "blank")
      false
    end

    def valid_uk_address?(record, attribute, value)
      return true if value.address_mode == "address-results"
      return true if value.address_mode == "manual-uk"

      record.errors[attribute] << error_message(record, attribute, "should_be_uk")
      false
    end

    def error_message(record, attribute, error)
      class_name = record.class.to_s.underscore
      I18n.t("activemodel.errors.models.#{class_name}.attributes.#{attribute}.#{error}")
    end
  end
end
