# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantNameFormsController < FormsController
    def new
      super(ApplicantNameForm, "applicant_name_form")
    end

    def create
      super(ApplicantNameForm, "applicant_name_form")
    end
  end
end
