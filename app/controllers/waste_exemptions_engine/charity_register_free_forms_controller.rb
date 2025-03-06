# frozen_string_literal: true

module WasteExemptionsEngine
  class CharityRegisterFreeFormsController < FormsController
    def new
      super(CharityRegisterFreeForm, "charity_register_free_form")
    end
  end
end
