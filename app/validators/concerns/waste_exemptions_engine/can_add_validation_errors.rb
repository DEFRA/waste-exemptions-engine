# frozen_string_literal: true

module WasteExemptionsEngine
  module CanAddValidationErrors
    private

    def add_validation_error(record, attribute, error)
      # Move on if an error of this type with the same message has already been added
      message = error_message(record, attribute, error)
      return if record.errors.find { |e| e.type == error && e.message == message }

      record.errors.add(attribute, error, message:)
    end

    def error_message(record, attribute, error)
      class_name = record.class.to_s.underscore
      I18n.t("activemodel.errors.models.#{class_name}.attributes.#{attribute}.#{error}")
    end
  end
end
