# frozen_string_literal: true

module WasteExemptionsEngine
  class IdValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      valid_format?(record, attribute, value)
    end

    private

    def valid_format?(_record, _attribute, _value)
      true
      # Make sure the format of the reg_identifier is valid to prevent injection
      # Format should be CBDU or CBDL, followed by at least one digit
      # return true if value.present? && value.match?(/^CBD[U|L][0-9]+$/)

      # record.errors[attribute] << error_message(record, attribute, "invalid_format")
      # false
    end

    def error_message(record, attribute, error)
      class_name = record.class.to_s.underscore
      I18n.t("activemodel.errors.models.#{class_name}.attributes.#{attribute}.#{error}")
    end
  end
end
