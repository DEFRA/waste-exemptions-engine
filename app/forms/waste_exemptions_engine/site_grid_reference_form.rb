# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceForm < BaseForm
    include CanAddOrReplaceAnAddress

    delegate :grid_reference, :description, to: :transient_registration

    validates :grid_reference, "defra_ruby/validators/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true

    def submit(params)
      grid_reference = params[:grid_reference]&.upcase&.strip
      description = params[:description]&.strip

      transient_registration.update_attributes(
        temp_grid_reference: grid_reference,
        temp_site_description: description
      )

      new_address = create_address
      attributes = {
        site_address: new_address
      }

      super(attributes)
    end

    private

    def create_address
      return nil if grid_reference.blank?

      TransientAddress.create_from_grid_reference_data(
        { "grid_reference": grid_reference, "description": description },
        TransientAddress.address_types[:site]
      )
    end
  end
end
