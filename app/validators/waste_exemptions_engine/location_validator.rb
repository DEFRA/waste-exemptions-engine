# frozen_string_literal: true

module WasteExemptionsEngine
  class LocationValidator < BaseValidator
    def validate_each(record, attribute, value)
      valid_location?(record, attribute, value)
    end

    private

    def valid_location?(record, attribute, value)
      valid_locations = %w[england
                           northern_ireland
                           scotland
                           wales]

      return true if value.present? && valid_locations.include?(value)

      record.errors[attribute] << error_message(record, attribute, "inclusion")
      false
    end
  end
end
