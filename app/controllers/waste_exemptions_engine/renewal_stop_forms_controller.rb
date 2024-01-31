# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStopFormsController < FormsController
    def new
      super(RenewalStopForm, "renewal_stop_form")
    end

  end
end
