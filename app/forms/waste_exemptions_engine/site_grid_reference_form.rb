# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceForm < BaseForm
    delegate :site_address, to: :transient_registration
    delegate :grid_reference, :description, to: :site_address

    validates :grid_reference, "defra_ruby/validators/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true

    def submit(params)
      grid_reference = params[:grid_reference]&.upcase&.strip
      description = params[:description]&.strip

      new_address = create_address(grid_reference, description)
      attributes = {
        site_address: new_address
      }

      super(attributes)
    end

    private

    def create_address(grid_reference, description)
      return nil if grid_reference.blank?

      TransientAddress.create_from_grid_reference_data(
        { "grid_reference": grid_reference, "description": description },
        TransientAddress.address_types[:site]
      )
    end
  end
end
