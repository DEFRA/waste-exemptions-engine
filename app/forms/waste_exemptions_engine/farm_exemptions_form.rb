# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmExemptionsForm < BaseForm
    delegate :temp_exemptions, :temp_farm_exemptions, to: :transient_registration

    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

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
