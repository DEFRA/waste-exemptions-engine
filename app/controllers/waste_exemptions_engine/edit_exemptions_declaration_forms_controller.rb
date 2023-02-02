# frozen_string_literal: true

module WasteExemptionsEngine
  class EditExemptionsDeclarationFormsController < FormsController
    def new
      super(EditExemptionsDeclarationForm, "edit_exemptions_declaration_form")
    end
  end
end
