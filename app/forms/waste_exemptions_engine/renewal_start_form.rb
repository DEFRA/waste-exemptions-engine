# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartForm < BaseForm
    def submit(params)
      super({}, params[:token])
    end
  end
end
