# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsFormsController < FormsController
    def new
      super(ExemptionsForm, "exemptions_form")
    end

    def create
      super(ExemptionsForm, "exemptions_form")
    end
  end
end
