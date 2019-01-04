# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCompleteForm < BaseForm

    attr_accessor :reference, :exemptions_plural, :contact_email

    def initialize(enrollment)
      super
      self.reference = @enrollment.reference
      self.exemptions_plural = @enrollment.exemptions.length > 1 ? "many" : "one"
      self.contact_email = @enrollment.contact_email
    end

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit; end
  end
end
