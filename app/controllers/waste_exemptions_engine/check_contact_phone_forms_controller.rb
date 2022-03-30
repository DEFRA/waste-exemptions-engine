# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckContactPhoneFormsController < FormsController
    def new
      super(CheckContactPhoneForm, "check_contact_phone_form")
    end

    def create
      super(CheckContactPhoneForm, "check_contact_phone_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:check_contact_phone_form, {}).permit(:temp_reuse_applicant_phone)
    end
  end
end
