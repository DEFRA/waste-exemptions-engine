# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmExemptionsForm < BaseForm
    def submit(params)
      attributes = ExemptionParamsService.run(
        registration: transient_registration,
        exemption_type: :farm,
        new_exemptions: params[:temp_exemptions]
      )

      super(attributes)
    end
  end
end
