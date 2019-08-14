# frozen_string_literal: true

module WasteExemptionsEngine
  class EditCompleteForm < BaseForm
    attr_accessor :reference

    set_callback :initialize, :after, :set_reference

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit(_params)
      raise UnsubmittableForm
    end

    private

    def set_reference
      self.reference = @transient_registration.reference
    end
  end
end
