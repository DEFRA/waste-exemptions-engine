# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceForm < BaseForm
    attr_accessor :grid_reference, :description

    set_callback :initialize, :after, :set_grid_reference
    set_callback :initialize, :after, :set_description

    def submit(params)
      assign_params(params)

      @transient_registration.update_attributes(
        temp_grid_reference: grid_reference,
        temp_site_description: description
      )

      new_address = create_address
      attributes = {
        transient_addresses: add_or_replace_address(
          new_address,
          @transient_registration.transient_addresses
        )
      }

      super(attributes, params[:token])
    end

    validates :grid_reference, "waste_exemptions_engine/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true

    private

    def set_grid_reference
      self.grid_reference = @transient_registration.temp_grid_reference
    end

    def set_description
      self.description = @transient_registration.temp_site_description
    end

    def assign_params(params)
      self.grid_reference = params[:grid_reference]&.upcase&.strip
      self.description = params[:description]&.strip
    end

    def existing_address
      @transient_registration.site_address
    end

    def create_address
      return nil if grid_reference.blank?

      TransientAddress.create_from_grid_reference_data(
        { "grid_reference": grid_reference, "description": description },
        TransientAddress.address_types[:site]
      )
    end

    def add_or_replace_address(address, existing_addresses)
      return existing_addresses unless address

      # Update the registration's nested addresses, replacing any existing address
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
