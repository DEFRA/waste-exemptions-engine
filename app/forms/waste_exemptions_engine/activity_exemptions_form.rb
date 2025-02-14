# frozen_string_literal: true

module WasteExemptionsEngine
  class ActivityExemptionsForm < BaseForm
    delegate :temp_exemptions, to: :transient_registration

    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      # Get the current exemptions
      current_exemptions = Array(temp_exemptions)
      new_exemptions = Array(params[:temp_exemptions])

      # Update with new exemptions
      attributes = { temp_exemptions: (current_exemptions + new_exemptions).uniq.sort }

      super(attributes)
    end
  end
end
