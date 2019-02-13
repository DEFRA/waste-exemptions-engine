# frozen_string_literal: true

module WasteExemptionsEngine
  class BaseValidator < ActiveModel::EachValidator

    protected

    def error_message(record, attribute, error)
      class_name = record.class.to_s.underscore
      I18n.t("activemodel.errors.models.#{class_name}.attributes.#{attribute}.#{error}")
    end
  end
end
