# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInWalesFormsController < FormsController
    def new
      super(RegisterInWalesForm, "register_in_wales_form")
    end

    def create
      super(RegisterInWalesForm, "register_in_wales_form")
    end
  end
end
