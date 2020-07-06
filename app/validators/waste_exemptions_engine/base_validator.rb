# frozen_string_literal: true

module WasteExemptionsEngine
  class BaseValidator < ActiveModel::EachValidator
    include CanAddValidationErrors
  end
end
