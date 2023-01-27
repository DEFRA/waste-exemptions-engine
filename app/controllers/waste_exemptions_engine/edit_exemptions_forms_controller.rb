# frozen_string_literal: true

module WasteExemptionsEngine
  class EditExemptionsFormsController < FormsController
    def new
      super(EditExemptionsForm, "edit_exemptions_form")
    end

    def create
      super(EditExemptionsForm, "edit_exemptions_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:edit_exemptions_form, {}).permit(exemption_ids: [])
    end
  end
end
