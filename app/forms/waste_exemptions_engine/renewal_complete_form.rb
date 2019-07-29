# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalCompleteForm < BaseForm
    # Override BaseForm method as users shouldn't be able to submit this form
    def submit(_params)
      raise UnsubmittableForm
    end

    def self.can_navigate_flexibly?
      false
    end
  end
end
