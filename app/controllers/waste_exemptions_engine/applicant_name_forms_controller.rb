# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantNameFormsController < FormsController
    def new
      super(ApplicantNameForm, "applicant_name_form")
    end

    def create
      super(ApplicantNameForm, "applicant_name_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:applicant_name_form, {}).permit(:applicant_first_name, :applicant_last_name)
    end
  end
end
