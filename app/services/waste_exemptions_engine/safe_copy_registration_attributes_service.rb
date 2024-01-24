# frozen_string_literal: true

module WasteExemptionsEngine
  class SafeCopyRegistrationAttributesService < BaseService

    def run(source:, target_class:, exclude: [])
      source_attributes = source.attributes.except(*exclude)

      unsupported_attribute_keys = source_attributes.except(*target_class.column_names).keys

      source_attributes.except(*unsupported_attribute_keys)
    end
  end
end
