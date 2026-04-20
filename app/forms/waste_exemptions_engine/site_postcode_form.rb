# frozen_string_literal: true

module WasteExemptionsEngine
  class SitePostcodeForm < BasePostcodeForm
    include CanRestrictSiteLocationsToEngland

    delegate :business_type, :temp_site_postcode, to: :transient_registration

    validates :temp_site_postcode, "defra_ruby/validators/postcode": true
    validate :postcode_returns_selectable_addresses

    def initialize(transient_registration)
      super
      transient_registration.update(temp_site_postcode: nil) if transient_registration.multisite?
    end

    def submit(params)
      params[:temp_site_postcode] = format_postcode(params[:temp_site_postcode])

      # We persist the postcode regardless of validations.
      transient_registration.update(params)

      super({})
    end

    private

    def postcode_returns_selectable_addresses
      return if skip_postcode_lookup_validation?

      handle_address_lookup_response(AddressLookupService.run(temp_site_postcode))
    end

    def skip_postcode_lookup_validation?
      temp_site_postcode.blank? ||
        errors.added?(:temp_site_postcode, :blank) ||
        errors.added?(:temp_site_postcode, :wrong_format)
    end

    def handle_address_lookup_response(response)
      return handle_successful_address_lookup(response) if response.successful?
      return errors.add(:temp_site_postcode, :no_results) if response.error.is_a?(DefraRuby::Address::NoMatchError)

      address_finder_errored!
    end

    def handle_successful_address_lookup(response)
      return if selectable_address_found?(response.results)

      errors.add(:temp_site_postcode, :not_in_england)
    end

    def selectable_address_found?(results)
      results.any? do |address|
        site_location_in_england?(easting: address["x"], northing: address["y"])
      end
    end
  end
end
