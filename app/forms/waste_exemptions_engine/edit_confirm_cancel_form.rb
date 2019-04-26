# frozen_string_literal: true

module WasteExemptionsEngine
  class EditConfirmCancelForm < BaseForm
    def initialize(registration)
      super
    end

    def submit(params)
      super({}, params[:token])
    end
  end
end
