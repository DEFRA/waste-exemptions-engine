# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmRenewalFormsController < FormsController
    def new
      super(ConfirmRenewalForm, "confirm_renewal_form")
    end

    def create
      super(ConfirmRenewalForm, "confirm_renewal_form")
    end
  end
end
