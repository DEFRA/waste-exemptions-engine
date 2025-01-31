# frozen_string_literal: true

module WasteExemptionsEngine
  class ActivityExemptionsForm < BaseForm
    delegate :temp_exemptions, :temp_confirm_exemptions, to: :transient_registration

    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      if !temp_confirm_exemptions
        combined_exemptions = temp_exemptions + params[:temp_exemptions]
        attributes = { temp_exemptions: combined_exemptions }
      else
        attributes = { temp_exemptions: params[:temp_exemptions] }
      end

      super(attributes)
    end
  end
end
