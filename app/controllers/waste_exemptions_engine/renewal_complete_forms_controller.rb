# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalCompleteFormsController < FormsController
    def new
      return unless super(RenewalCompleteForm, "renewal_complete_form")
    end

    # Overwrite create and go_back as you shouldn't be able to submit or go back
    def create; end

    def go_back; end
  end
end
