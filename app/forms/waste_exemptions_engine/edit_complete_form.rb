# frozen_string_literal: true

module WasteExemptionsEngine
  class EditCompleteForm < BaseForm
    include CanSetReference

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit(_params)
      raise UnsubmittableForm
    end
  end
end
