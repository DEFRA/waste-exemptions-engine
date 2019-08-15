# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewWithoutChangesForm < BaseForm
    def submit(_params)
      super({})
    end
  end
end
