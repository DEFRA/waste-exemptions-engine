# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceForm < BaseForm
    attr_accessor :grid_reference, :description

    validates :grid_reference, "defra_ruby/validators/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true

    def initialize(registration)
      super
      self.grid_reference = @transient_registration.temp_grid_reference
      self.description = @transient_registration.temp_site_description
    end

    def submit(params)
      assign_params(params)

      # TODO: These should be removed along with the `transient_registration` temp fields.
      @transient_registration.update_attributes(
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

    def assign_params(params)
      self.grid_reference = params[:grid_reference]&.upcase&.strip
      self.description = params[:description]&.strip
    end

    def create_address
      return nil if grid_reference.blank?

      TransientAddress.create_from_grid_reference_data(
        { "grid_reference": grid_reference, "description": description },
        TransientAddress.address_types[:site]
      )
    end
  end
end
