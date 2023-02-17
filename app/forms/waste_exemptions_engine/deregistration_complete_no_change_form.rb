# frozen_string_literal: true

module WasteExemptionsEngine
  class DeregistrationCompleteNoChangeForm < BaseForm
    delegate :reference, to: :transient_registration

    def submit(_params)
      raise UnsubmittableForm
    end

    def self.can_navigate_flexibly?
      false
    end
  end
end
