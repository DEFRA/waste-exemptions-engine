# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationLookupValidator < ActiveModel::Validator
    include CanAddValidationErrors

    def validate(record)
      registration = Registration.where(reference: record.reference).first

      return false unless valid_reference?(record, registration)
      return false unless editable_status?(record, registration)
    end

    private

    def valid_reference?(record, registration)
      return true if registration.present?

      record.errors.add(:reference, :no_match)
      false
    end

    def editable_status?(record, registration)
      return true if registration.active_exemptions.any?

      record.errors.add(:reference, :inactive)
      false
    end
  end
end
