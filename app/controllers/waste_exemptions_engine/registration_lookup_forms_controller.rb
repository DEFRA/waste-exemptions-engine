# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationLookupFormsController < FormsController
    def new
      super(RegistrationLookupForm, "registration_lookup_form")
    end

    def create
      return false unless set_up_form(RegistrationLookupForm, "registration_lookup_form", params[:token])

      submit_form(@registration_lookup_form, transient_registration_attributes)
    end

    private

    def transient_registration_attributes
      params.fetch(:registration_lookup_form, {}).permit(:reference)
    end

    def submit_form(form, params)
      respond_to do |format|
        if form.submit(params)
          format.html { redirect_to_registration_lookup_email_journey }
          true
        else
          format.html { render :new }
          false
        end
      end
    end

    def redirect_to_registration_lookup_email_journey
      @transient_registration.next_state!
      redirect_to_correct_form
    end
  end
end
