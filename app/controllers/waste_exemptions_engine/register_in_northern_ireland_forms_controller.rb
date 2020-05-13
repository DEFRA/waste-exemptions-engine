# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInNorthernIrelandFormsController < FormsController
    include UnsubmittableForm

    def new
      super(RegisterInNorthernIrelandForm, "register_in_northern_ireland_form")
    end
  end
end
