# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInNorthernIrelandFormsController < FormsController
    def new
      super(RegisterInNorthernIrelandForm, "register_in_northern_ireland_form")
    end

    # Override this method as user shouldn't be able to "submit" this page
    def create; end
  end
end
