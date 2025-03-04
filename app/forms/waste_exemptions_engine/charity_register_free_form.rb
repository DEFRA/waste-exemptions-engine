# frozen_string_literal: true

module WasteExemptionsEngine
  class CharityRegisterFreeForm < BaseForm
    # This is a final state, so we don't want users to be able to navigate to it flexibly
    def self.can_navigate_flexibly?
      false
    end

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit(_params)
      raise UnsubmittableForm
    end
  end
end
