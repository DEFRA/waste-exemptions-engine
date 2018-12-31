# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :grid_reference, :description

    def initialize(enrollment)
      super
      self.grid_reference = @enrollment.interim.grid_reference
      self.description = @enrollment.interim.site_description
    end

    def submit(params)
      assign_params(params)

      @enrollment.interim.update_attributes(
        grid_reference: grid_reference,
        site_description: description
      )

      new_address = create_address
      attributes = {
        addresses: add_or_replace_address(
          new_address,
          @enrollment.addresses
        )
      }

      super(attributes, params[:token])
    end

    validates :grid_reference, "waste_exemptions_engine/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true

    private

    def assign_params(params)
      # Strip out whitespace from start and end
      params.each { |_key, value| value.strip! }

      self.grid_reference = params[:grid_reference]&.upcase
      self.description = params[:description]
    end

    def existing_address
      @enrollment.site_address
    end

    def create_address
      return nil if grid_reference.blank?

      Address.create_from_grid_reference_data(
        { "grid_reference": grid_reference, "description": description },
        Address.address_types[:site]
      )
    end

    def add_or_replace_address(address, existing_addresses)
      return existing_addresses unless address

      # Update the enrollment's nested addresses, replacing any existing address
      # of the same type
      updated_addresses = existing_addresses
      matched_address = updated_addresses.find(existing_address.id) if existing_address

      if matched_address
        updated_addresses.delete(matched_address)
        matched_address.delete
      end

      updated_addresses << address

      updated_addresses
    end
  end
end
