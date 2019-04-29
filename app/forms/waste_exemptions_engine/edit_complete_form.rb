# frozen_string_literal: true

module WasteExemptionsEngine
  class EditCompleteForm < BaseForm

    attr_accessor :reference

    def initialize(registration)
      super
      self.reference = @transient_registration.reference
    end

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit(_params)
      raise UnsubmittableForm
    end
  end
end
