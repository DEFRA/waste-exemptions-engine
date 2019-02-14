# frozen_string_literal: true

module WasteExemptionsEngine
  class LocationValidator < BaseValidator
    include CanValidateSelection

    def validate_each(record, attribute, value)
      valid_locations = %w[england
                           northern_ireland
                           scotland
                           wales]

      value_is_included?(record, attribute, value, valid_locations)
    end
  end
end
