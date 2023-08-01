# frozen_string_literal: true

module WasteExemptionsEngine
  class CaptureCompleteForm < BaseForm
    def submit(_params)
      raise UnsubmittableForm
    end

    def self.can_navigate_flexibly?
      false
    end
  end
end
