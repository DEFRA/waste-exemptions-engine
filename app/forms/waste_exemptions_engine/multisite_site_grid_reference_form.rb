# frozen_string_literal: true

module WasteExemptionsEngine
  class MultisiteSiteGridReferenceForm < BaseForm
    attr_accessor :grid_reference, :description

    validates :grid_reference, "defra_ruby/validators/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true

    def submit(params)
      @grid_reference = params[:grid_reference]
      @description = params[:description]

      return false unless valid?

      # Create new site address for the multisite registration
      transient_registration.transient_addresses.create!(
        grid_reference: @grid_reference,
        description: @description,
        address_type: "site",
        mode: "auto"
      )

      true
    end
  end
end
