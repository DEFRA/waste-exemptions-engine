# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCompleteForm < BaseForm
    delegate :exemptions, :reference, :applicant_email, :contact_email, to: :transient_registration

    def self.can_navigate_flexibly?
      false
    end
  end
end
