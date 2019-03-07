# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInNorthernIrelandForm < BaseForm
    # Override BaseForm method as users shouldn't be able to submit this form
    def submit(params)
      raise UnsubmittableForm
    end
  end
end
