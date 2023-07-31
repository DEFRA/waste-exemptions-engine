# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationLookupEmailFormsController < FormsController
    def new
      super(RegistrationLookupEmailForm, "registration_lookup_email_form")
    end

    def create
      return false unless set_up_form(RegistrationLookupEmailForm, "registration_lookup_email_form", params[:token])

      submit_form(@registration_lookup_email_form, transient_registration_attributes)
    end

    private

    def transient_registration_attributes
      params.fetch(:registration_lookup_email_form, {}).permit(:reference, :contact_email)
    end

    def submit_form(form, params)
      respond_to do |format|
        if form.submit(params)
          run_jon_to_check_email_and_send_edit_link
          format.html { redirect_to_registration_lookup_confirmation_journey }
          true
        else
          format.html { render :new }
          false
        end
      end
    end

    def run_jon_to_check_email_and_send_edit_link
      # Run a background job to check if email matches the one in the registration record and send the edit link
      # to the email address if it does
      # @todo - Implement backgroundd job and call it here
      # CheckEmailAndSendEditLinkJob.perform_later(@registration_lookup_email_form)
    end

    def redirect_to_registration_lookup_confirmation_journey
      @transient_registration.next_state!
      redirect_to_correct_form
    end
  end
end
