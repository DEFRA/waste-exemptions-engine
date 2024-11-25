# frozen_string_literal: true

module WasteExemptionsEngine
  class ActivityExemptionsForm < BaseForm
    delegate :temp_exemptions, to: :transient_registration

    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      attributes = { temp_exemptions: params[:temp_exemptions] }

      super(attributes)
    end
  end
end
