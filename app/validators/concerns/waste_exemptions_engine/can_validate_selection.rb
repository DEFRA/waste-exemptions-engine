# frozen_string_literal: true

module WasteExemptionsEngine
  module CanValidateSelection
    extend ActiveSupport::Concern

    included do
      private

      def value_is_included?(record, attribute, value, valid_options)
        return true if value.present? && valid_options.include?(value)

        record.errors[attribute] << error_message(record, attribute, "inclusion")
        false
      end
    end
  end
end
