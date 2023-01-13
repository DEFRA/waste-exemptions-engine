# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewExemptionsFormsController < FormsController
    def new
      super(RenewExemptionsForm, "renew_exemptions_form")
    end

    def create
      super(RenewExemptionsForm, "renew_exemptions_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:renew_exemptions_form, {}).permit(exemption_ids: [])
    end
  end
end
