# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsFormsController < FormsController
    def new
      super(ExemptionsForm, "exemptions_form")
    end

    def create
      super(ExemptionsForm, "exemptions_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:exemptions_form, {}).permit(exemption_ids: [])
    end
  end
end
