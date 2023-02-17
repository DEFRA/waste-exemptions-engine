# frozen_string_literal: true

module WasteExemptionsEngine
  class EditExemptionsDeclarationFormsController < FormsController
    def new
      super(EditExemptionsDeclarationForm, "edit_exemptions_declaration_form")
    end

    def create
      super(EditExemptionsDeclarationForm, "edit_exemptions_declaration_form")

      ExemptionDeregistrationService.run(@transient_registration)
    end

    private

    def transient_registration_attributes
      params.fetch(:edit_exemptions_declaration_form, {}).permit(:declaration)
    end
  end
end
