# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInScotlandFormsController < FormsController
    def new
      super(RegisterInScotlandForm, "register_in_scotland_form")
    end

    # Override this method as user shouldn't be able to "submit" this page
    def create; end
  end
end
