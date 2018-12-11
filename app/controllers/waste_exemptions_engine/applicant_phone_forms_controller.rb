# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantPhoneFormsController < FormsController
    def new
      super(ApplicantPhoneForm, "applicant_phone_form")
    end

    def create
      super(ApplicantPhoneForm, "applicant_phone_form")
    end
  end
end
