# frozen_string_literal: true

module WasteExemptionsEngine
  class DeclarationFormsController < FormsController
    def new
      super(DeclarationForm, "declaration_form")
    end

    def create
      super(DeclarationForm, "declaration_form")
    end
  end
end
