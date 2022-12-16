# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewNoExemptionsFormsController < FormsController
    def new
      super(RenewNoExemptionsForm, "renew_no_exemptions_form")
    end
  end
end
