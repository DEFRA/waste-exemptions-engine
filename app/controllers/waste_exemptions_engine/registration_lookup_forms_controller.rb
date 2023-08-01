# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationLookupFormsController < FormsController
    def new
      super(RegistrationLookupForm, "registration_lookup_form")
    end

    def create
      return false unless set_up_form(RegistrationLookupForm, "registration_lookup_form", params[:token])

      super(RegistrationLookupForm, "registration_lookup_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:registration_lookup_form, {}).permit(:reference)
    end
  end
end
