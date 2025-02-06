# frozen_string_literal: true

module WasteExemptionsEngine
  class ActivityExemptionsForm < BaseForm
    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      attributes = UpdateExemptionsService.run(
        registration: transient_registration,
        exemption_type: :activity,
        new_exemptions: params[:temp_exemptions]
      )

      super(attributes)
    end
  end
end
