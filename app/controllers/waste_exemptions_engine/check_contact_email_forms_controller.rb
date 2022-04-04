# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckContactEmailFormsController < FormsController
    def new
      super(CheckContactEmailForm, "check_contact_email_form")
    end

    def create
      super(CheckContactEmailForm, "check_contact_email_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:check_contact_email_form, {}).permit(:temp_reuse_applicant_email)
    end
  end
end
