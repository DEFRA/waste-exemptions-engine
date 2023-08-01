# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationLookupEmailFormsController < FormsController
    def new
      super(RegistrationLookupEmailForm, "registration_lookup_email_form")
    end

    def create
      return false unless set_up_form(RegistrationLookupEmailForm, "registration_lookup_email_form", params[:token])

      @registration_lookup_email_form.contact_email = transient_registration_attributes[:contact_email]
      run_job_to_check_email_and_send_edit_link if @registration_lookup_email_form.valid?

      super(RegistrationLookupEmailForm, "registration_lookup_email_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:registration_lookup_email_form, {}).permit(:reference, :contact_email)
    end

    def run_job_to_check_email_and_send_edit_link
      # Run a background job to check if email matches the one in the registration record and send the edit link
      # to the email address if it does
      # @todo - Implement backgroundd job and call it here
      # CheckEmailAndSendEditLinkJob.perform_later(
      #  transient_registration_attributes[:reference],
      #  transient_registration_attributes[:contact_email]
      # )
    end
  end
end
