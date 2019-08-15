# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewWithoutChangesForm < BaseForm
    def submit(params)
      super({})
    end
  end
end
