# frozen_string_literal: true

module WasteExemptionsEngine
  module CanCreateAddressFromFinderData
    extend ActiveSupport::Concern

    included do
      def create_address(selected_address_uprn, type)
        return if selected_address_uprn.blank?

        data = temp_addresses.detect { |address| address["uprn"] == selected_address_uprn.to_i }
        return unless data

        address = TransientAddress.create_from_address_finder_data(data, type)

        address
      end
    end
  end
end
