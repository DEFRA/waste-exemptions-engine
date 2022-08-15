# frozen_string_literal: true

module WasteExemptionsEngine
  class OptionalEmailFormValidator < ActiveModel::EachValidator
    include CanAddValidationErrors

    def validate(record)
      email_address = record.send(attributes[0])
      if WasteExemptionsEngine.configuration.host_is_back_office? && record.no_email_address == "1"
        unless email_address.nil?
          add_validation_error(record, :no_email_address, :not_blank)
          return false
        end

        return true
      end

      if record.confirmed_email != email_address
        add_validation_error(record, :confirmed_email, :does_not_match)
        return false
      end

      DefraRuby::Validators::EmailValidator.new(attributes: attributes).validate(record)
    end
  end
end
