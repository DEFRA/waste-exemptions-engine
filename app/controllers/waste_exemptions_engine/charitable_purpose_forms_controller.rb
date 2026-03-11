# frozen_string_literal: true

module WasteExemptionsEngine
  class CharitablePurposeFormsController < FormsController
    def new
      super(CharitablePurposeForm, "charitable_purpose_form")
    end

    def create
      super(CharitablePurposeForm, "charitable_purpose_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:charitable_purpose_form, {}).permit(:charitable_purpose)
    end
  end
end
