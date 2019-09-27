# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsForm < BaseForm
    delegate :exemptions, to: :transient_registration

    validates :exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      super(exemptions: determine_matched_exemptions(params))
    end

    private

    def determine_matched_exemptions(params)
      return nil unless params[:exemptions]

      Exemption.where(id: params[:exemptions])
    end
  end
end
