# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmExemptionsForm < BaseForm
    delegate :temp_exemptions, :temp_farm_exemptions, to: :transient_registration

    validate :validate_exemptions

    def submit(params)
      attributes = ExemptionParamsService.run(
        registration: transient_registration,
        exemption_type: :farm,
        new_exemptions: params[:temp_exemptions]
      )

      super(attributes)
    end

    private

    def validate_exemptions
      return if temp_exemptions.nil?
      return if temp_exemptions.is_a?(Array)

      errors.add(:temp_exemptions, :invalid)
    end
  end
end
