# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartFormsController < FormsController
    def new
      super(RenewalStartForm, "renewal_start_form")
    end

    def create
      super(RenewalStartForm, "renewal_start_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:renewal_start_form, {}).permit(:temp_renew_without_changes)
    end
  end
end
