# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditDeclarationFormsController < FormsController
    def new
      super(FrontOfficeEditDeclarationForm, "front_office_edit_declaration_form")
    end

    def create
      super(FrontOfficeEditDeclarationForm, "front_office_edit_declaration_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:front_office_edit_declaration_form, {}).permit(:declaration)
    end
  end
end
