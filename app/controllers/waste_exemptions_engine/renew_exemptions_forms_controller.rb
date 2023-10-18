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
      # reverse_merge adds empty exemption_ids array if not already present
      params.fetch(:renew_exemptions_form, {}).permit(exemption_ids: []).reverse_merge({ exemption_ids: [] })
    end
  end
end
