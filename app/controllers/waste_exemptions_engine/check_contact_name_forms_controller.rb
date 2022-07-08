# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckContactNameFormsController < FormsController
    def new
      super(CheckContactNameForm, "check_contact_name_form")
    end

    def create
      super(CheckContactNameForm, "check_contact_name_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:check_contact_name_form, {}).permit(:temp_reuse_applicant_name)
    end
  end
end
