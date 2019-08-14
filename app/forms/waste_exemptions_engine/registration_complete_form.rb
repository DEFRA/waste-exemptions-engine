# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCompleteForm < BaseForm
    attr_accessor :reference, :exemptions_plural, :applicant_email, :contact_email, :emails_plural

    set_callback :initialize, :after, :set_reference
    set_callback :initialize, :after, :set_exemptions_plural
    set_callback :initialize, :after, :set_applicant_email
    set_callback :initialize, :after, :set_contact_email
    set_callback :initialize, :after, :set_emails_plural

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit(_params)
      raise UnsubmittableForm
    end

    def self.can_navigate_flexibly?
      false
    end

    private

    def set_reference
      self.reference = @transient_registration.reference
    end

    def set_exemptions_plural
      self.exemptions_plural = @transient_registration.exemptions.length > 1 ? "many" : "one"
    end

    def set_applicant_email
      self.applicant_email = @transient_registration.applicant_email
    end

    def set_contact_email
      self.contact_email = @transient_registration.contact_email
    end

    def set_emails_plural
      self.emails_plural = applicant_email == contact_email ? "one" : "many"
    end
  end
end
