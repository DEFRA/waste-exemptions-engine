# frozen_string_literal: true

module WasteExemptionsEngine
  module CanValidateLength
    extend ActiveSupport::Concern

    included do
      private

      def value_is_not_too_long?(record, attribute, value, max_length)
        return true if value.length <= max_length

        record.errors[attribute] << error_message(record, attribute, "too_long")
        false
      end
    end
  end
end
