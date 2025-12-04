# frozen_string_literal: true

module WasteExemptionsEngine
  module CanCopyAddressesAndExemptions
    extend ActiveSupport::Concern

    private

    def copy_addresses
      # Build mapping from transient addresses to new addresses for use in copy_exemptions
      @addresses_mapping = {}

      # IMPORTANT: Clear registration_exemptions BEFORE clearing addresses
      # This prevents cascade delete (dependent: :destroy on Address) from destroying exemptions
      @registration.registration_exemptions = []

      # Now safe to clear addresses without cascade deleting exemptions
      @registration.addresses = []
      @edit_registration.transient_addresses.each do |transient_address|
        new_address = Address.new(transient_address.address_attributes)
        @registration.addresses << new_address
        @addresses_mapping[transient_address.id] = new_address
      end
    end

    def copy_exemptions
      # Recreate registration_exemptions from transient_registration_exemptions
      # with addresses properly mapped to the new address objects
      @edit_registration.transient_registration_exemptions.each do |transient_exemption|
        new_address = @addresses_mapping[transient_exemption.transient_address_id]
        @registration.registration_exemptions << RegistrationExemption.new(
          transient_exemption.exemption_attributes.merge(address: new_address)
        )
      end
    end

    def preload_associations_for_destruction
      # Preload associations that will be destroyed (dependent: :destroy)
      @registration = @registration.class.includes(addresses: :registration_exemptions).find(@registration.id)
    end
  end
end
