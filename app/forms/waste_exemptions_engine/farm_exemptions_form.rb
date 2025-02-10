# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmExemptionsForm < BaseForm
    delegate :temp_farm_exemptions, to: :transient_registration
    attr_accessor :temp_exemptions

    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      self.temp_exemptions = params[:temp_exemptions]

      return false unless valid?

      attributes = ExemptionParamsService.run(
        registration: transient_registration,
        exemption_type: :farm,
        new_exemptions: temp_exemptions
      )

      super(attributes)
    end
  end
end
