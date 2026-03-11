# frozen_string_literal: true

module WasteExemptionsEngine
  class CharitablePurposeDeclarationFormsController < FormsController
    def new
      super(CharitablePurposeDeclarationForm, "charitable_purpose_declaration_form")
    end

    def create
      super(CharitablePurposeDeclarationForm, "charitable_purpose_declaration_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:charitable_purpose_declaration_form, {}).permit(:charitable_purpose_declaration)
    end
  end
end
