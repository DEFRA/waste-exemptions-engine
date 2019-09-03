# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCompleteForm < BaseForm
    attr_accessor :reference, :applicant_email, :contact_email

    delegate :exemptions, to: :transient_registration

    def initialize(registration)
      super

      self.reference = @transient_registration.reference
      self.applicant_email = @transient_registration.applicant_email
      self.contact_email = @transient_registration.contact_email
    end

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit(_params)
      raise UnsubmittableForm
    end

    def self.can_navigate_flexibly?
      false
    end
  end
end
