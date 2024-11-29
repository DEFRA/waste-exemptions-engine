# frozen_string_literal: true

module WasteExemptionsEngine
  class WasteActivitiesValidator < BaseValidator
    def validate_each(record, attribute, value)
      return true if value.present? && value.length.positive?

      add_validation_error(record, attribute, :inclusion)
      false
    end
  end
end
