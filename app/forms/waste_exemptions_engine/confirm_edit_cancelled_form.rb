# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmEditCancelledForm < BaseForm
    def initialize(registration)
      super
    end

    def submit(params)
      super({}, params[:token])
    end
  end
end
