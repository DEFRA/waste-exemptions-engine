# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartForm < BaseForm
    attr_accessor :temp_renew_without_changes

    def submit(params)
      super({}, params[:token])
    end
  end
end
