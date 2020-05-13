# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInWalesFormsController < FormsController
    include UnsubmittableForm

    def new
      super(RegisterInWalesForm, "register_in_wales_form")
    end
  end
end
