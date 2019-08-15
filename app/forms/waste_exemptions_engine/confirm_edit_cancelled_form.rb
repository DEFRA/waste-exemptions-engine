# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmEditCancelledForm < BaseForm
    def initialize(registration)
      super
    end

    def submit(_params)
      super({})
    end
  end
end
