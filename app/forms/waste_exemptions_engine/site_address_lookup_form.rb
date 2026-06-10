# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressLookupForm < AddressLookupFormBase
    include CanRestrictSiteLocationsToEngland

    delegate :temp_site_postcode, to: :transient_registration

    # This virtual attribute is validated using AddressValidator and populated
    # from incoming params (e.g. { site_address: { uprn: "123" } })
    attr_accessor :site_address

    alias postcode temp_site_postcode

    # For the view - returns the actual Address object or nil
    def existing_address
      transient_registration.site_address
    end

    def show_england_only_results_notice?
      !!@show_england_only_results_notice
    end

    validates :site_address, "waste_exemptions_engine/address": true
    validate :selected_address_must_be_in_england, if: :check_selected_address_location?

    def submit(params)
      site_address_params = params.fetch(:site_address, {})
      # Set for validation (expects a hash with :uprn or :postcode)
      @site_address = site_address_params

      address_attributes = get_address_data(site_address_params[:uprn], :site)

      return false unless valid? && address_attributes.present?

      SaveSiteAddressService.run(
        transient_registration: transient_registration,
        address_attributes: address_attributes,
        mode: :lookup
      )
    end

    private

    def multisite_registration?
      ActiveModel::Type::Boolean.new.cast(transient_registration.is_multisite_registration)
    end

    def request_matching_addresses
      matching_addresses = super

      english_addresses = matching_addresses.select do |address|
        site_location_allowed?(easting: address["x"], northing: address["y"])
      end

      @show_england_only_results_notice = english_addresses.any? &&
                                          english_addresses.length < matching_addresses.length

      english_addresses
    end

    def check_selected_address_location?
      restrict_site_locations_to_england? && site_address.present? && site_address[:uprn].present?
    end

    def selected_address_must_be_in_england
      return if selected_address_in_filtered_results?

      errors.add(:site_address, :not_in_england)
    end

    def selected_address_in_filtered_results?
      get_address_data(site_address[:uprn], :site).present?
    end
  end
end
