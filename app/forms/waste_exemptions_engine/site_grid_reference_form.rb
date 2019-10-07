# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceForm < BaseForm
    delegate :site_address, to: :transient_registration
    delegate :grid_reference, :description, to: :site_address, allow_nil: true

    validates :grid_reference, "defra_ruby/validators/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true

    def submit(params)
      params.merge!(address_type: :site, mode: :auto)

      super(site_address_attributes: params)
    end
  end
end
