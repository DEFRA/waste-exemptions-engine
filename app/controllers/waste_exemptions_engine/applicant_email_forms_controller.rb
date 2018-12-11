# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantEmailFormsController < FormsController
    def new
      super(ApplicantEmailForm, "applicant_email_form")
    end

    def create
      super(ApplicantEmailForm, "applicant_email_form")
    end
  end
end
