# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsForm < BaseForm
    delegate :exemptions, to: :transient_registration

    validates :exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      attributes = { exemption_ids: params[:exemption_ids] }

      super(attributes)
    end
  end
end
