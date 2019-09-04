# frozen_string_literal: true

module WasteExemptionsEngine
  module CanAddOrReplaceAnAddress
    extend ActiveSupport::Concern

    included do
      def add_or_replace_address(address, existing_addresses, existing_address)
        return existing_addresses unless address

        # Update the registration's nested addresses, replacing any existing address of the same type
        updated_addresses = existing_addresses
        matched_address = existing_addresses.find(existing_address.id) if existing_address

        if matched_address
          updated_addresses.delete(matched_address)
          matched_address.delete
        end

        updated_addresses << address if address

        updated_addresses
      end
    end
  end
end
