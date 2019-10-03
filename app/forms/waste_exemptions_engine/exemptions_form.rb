# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsForm < BaseForm
    delegate :exemptions, to: :transient_registration

    validates :exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      # Rails authomatically delete params for which the value is empty :/
      params ||= {}

      super(exemption_ids: (params[:exemption_ids] || []))
    end
  end
end
