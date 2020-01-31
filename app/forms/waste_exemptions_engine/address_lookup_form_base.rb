# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressLookupFormBase < BaseForm
    attr_accessor :temp_addresses

    after_initialize :look_up_addresses

    private

    # Look up addresses based on the postcode
    def look_up_addresses
      self.temp_addresses = if postcode.present?
                              request_matching_addresses
                            else
                              []
                            end
    end

    def request_matching_addresses
      AddressLookupService.run(postcode).results
    end

    def get_address_data(uprn, type)
      return {} if uprn.blank?

      data = temp_addresses.detect { |address| address["uprn"] == uprn.to_i }
      return {} unless data

      data
        .except("address")
        .except("state_date")
        .merge(address_type: type, mode: :lookup)
    end
  end
end
