# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCompleteForm < BaseForm

    attr_accessor :reference, :exemptions_plural, :applicant_email, :contact_email, :emails_plural

    def initialize(registration)
      super
      self.reference = @transient_registration.reference
      self.exemptions_plural = @transient_registration.exemptions.length > 1 ? "many" : "one"
      self.applicant_email = @transient_registration.applicant_email
      self.contact_email = @transient_registration.contact_email
      self.emails_plural = applicant_email == contact_email ? "one" : "many"
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
