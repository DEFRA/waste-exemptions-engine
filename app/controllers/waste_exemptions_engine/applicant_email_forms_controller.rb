# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantEmailFormsController < FormsController
    def new
      super(ApplicantEmailForm, "applicant_email_form")
    end

    def create
      super(ApplicantEmailForm, "applicant_email_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:applicant_email_form, {}).permit(:confirmed_email, :applicant_email, :no_email_address)
    end
  end
end
