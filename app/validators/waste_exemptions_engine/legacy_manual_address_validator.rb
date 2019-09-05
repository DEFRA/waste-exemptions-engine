# frozen_string_literal: true

module WasteExemptionsEngine
  class LegacyManualAddressValidator < ActiveModel::Validator
    include CanValidatePresence
    include CanValidateLength

    VALIDATION_REQUIREMENTS = {
      premises: { presence: true, max_length: 200 },
      street_address: { presence: true, max_length: 160 },
      locality: { presence: false, max_length: 70 },
      city: { presence: true, max_length: 30 },
      postcode: { presence: false, max_length: 8 }
    }.freeze

    def validate(record)
      VALIDATION_REQUIREMENTS.each do |attribute, requirement|
        value = record.send(attribute)
        value_is_present?(record, attribute, value) if requirement[:presence]
        value_is_not_too_long?(record, attribute, value, requirement[:max_length]) if value && requirement[:max_length]
      end

      record.errors.empty?
    end

    private

    def error_message(record, attribute, error)
      class_name = record.class.to_s.underscore
      I18n.t("activemodel.errors.models.#{class_name}.attributes.#{attribute}.#{error}")
    end
  end
end
