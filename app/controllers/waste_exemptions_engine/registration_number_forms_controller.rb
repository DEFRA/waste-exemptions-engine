# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationNumberFormsController < FormsController
    def new
      super(RegistrationNumberForm, "registration_number_form")
    end

    def create
      super(RegistrationNumberForm, "registration_number_form")
    end
  end
end
