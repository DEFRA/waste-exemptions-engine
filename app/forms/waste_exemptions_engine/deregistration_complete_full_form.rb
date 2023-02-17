# frozen_string_literal: true

module WasteExemptionsEngine
  class DeregistrationCompleteFullForm < BaseForm
    delegate :exemptions, :reference, :contact_email, to: :transient_registration

    def submit(_params)
      raise UnsubmittableForm
    end

    def self.can_navigate_flexibly?
      false
    end
  end
end
