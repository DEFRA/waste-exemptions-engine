# frozen_string_literal: true

module WasteExemptionsEngine
  class EditCompleteForm < BaseForm

    delegate :reference, to: :transient_registration

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit(_params)
      raise UnsubmittableForm
    end
  end
end
