# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsForm < BaseForm
    attr_accessor :exemptions

    validates :exemptions, "waste_exemptions_engine/exemptions": true

    def initialize(registration)
      super

      self.exemptions = @transient_registration.exemptions
    end

    def submit(params)
      self.exemptions = determine_matched_exemptions(params)

      super(exemptions: exemptions)
    end

    private

    def determine_matched_exemptions(params)
      return nil unless params[:exemptions]

      Exemption.where(id: params[:exemptions])
    end
  end
end
