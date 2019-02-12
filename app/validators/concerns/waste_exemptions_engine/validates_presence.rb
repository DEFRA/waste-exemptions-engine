# frozen_string_literal: true

module WasteExemptionsEngine
  module ValidatesPresence
    extend ActiveSupport::Concern

    included do
      private

      def value_is_present?(record, attribute, value)
        return true if value.present?

        record.errors[attribute] << error_message(record, attribute, "blank")
        false
      end
    end
  end
end
