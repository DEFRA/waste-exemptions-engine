# frozen_string_literal: true

require "os_map_ref"

module WasteExemptionsEngine
  class GridReferenceValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return false unless value_is_present?(record, attribute, value)
      return false unless value_has_valid_format?(record, attribute, value)

      value_is_valid_coordinate?(record, attribute, value)
    end

    private

    def value_is_present?(record, attribute, value)
      return true if value.present?

      record.errors[attribute] << error_message(record, attribute, "blank")
      false
    end

    # Note that OsMapRef will work with less stringent coordinates than are
    # specified for this service - so we need to add an additional check
    def value_has_valid_format?(record, attribute, value)
      return true if value.match?(/\A#{grid_reference_pattern}\z/)

      record.errors[attribute] << error_message(record, attribute, "wrong_format")
      false
    end

    def value_is_valid_coordinate?(record, attribute, value)
      OsMapRef::Location.for(value).easting
      true
    rescue OsMapRef::Error
      record.errors[attribute] << error_message(record, attribute, "invalid")
      false
    end

    def grid_reference_pattern
      [two_letters, optional_space, five_digits, optional_space, five_digits].join
    end

    def two_letters
      "[A-Za-z]{2}"
    end

    def five_digits
      '\d{5}'
    end

    def optional_space
      '\s*'
    end

    def error_message(record, attribute, error)
      class_name = record.class.to_s.underscore
      I18n.t("activemodel.errors.models.#{class_name}.attributes.#{attribute}.#{error}")
    end
  end
end
