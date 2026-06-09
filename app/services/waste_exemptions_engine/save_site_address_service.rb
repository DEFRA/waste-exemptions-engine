# frozen_string_literal: true

module WasteExemptionsEngine
  class SaveSiteAddressService < BaseService
    SITE_LOCATION_ATTRIBUTES = %i[
      uprn
      organisation
      premises
      street_address
      locality
      city
      postcode
      x
      y
      coordinate_system
      blpu_state_code
      postal_address_code
      logical_status_code
      source_data_type
      country_iso
      grid_reference
      description
      area
    ].freeze

    def run(transient_registration:, address_attributes:, mode:)
      @transient_registration = transient_registration
      @address_attributes = address_attributes.to_h.symbolize_keys
      @mode = mode.to_s

      transient_registration.with_lock do
        transient_registration.reload
        attrs = normalized_site_address_attributes

        next true if adding_multisite_site? && duplicate_multisite_site_address?(attrs)

        site = site_address_to_save
        next false if site.blank?

        site.assign_attributes(attrs)
        AssignSiteDetailsService.run(address: site)
        site.save!
        true
      end
    end

    private

    attr_reader :transient_registration, :address_attributes, :mode

    def site_address_to_save
      if editing_site?
        return transient_registration.transient_addresses.site.find_by(id: transient_registration.temp_site_id)
      end

      return single_site_address unless multisite_registration?

      transient_registration.transient_addresses.build
    end

    def editing_site?
      transient_registration.temp_site_id.present?
    end

    def adding_multisite_site?
      !editing_site? && multisite_registration?
    end

    def single_site_address
      transient_registration.site_address || transient_registration.transient_addresses.build
    end

    def multisite_registration?
      ActiveModel::Type::Boolean.new.cast(transient_registration.is_multisite_registration)
    end

    def normalized_site_address_attributes
      reset_site_location_attributes.merge(address_attributes).merge(
        address_type: "site",
        mode: mode
      )
    end

    def reset_site_location_attributes
      SITE_LOCATION_ATTRIBUTES.index_with { nil }
    end

    def duplicate_multisite_site_address?(attrs)
      scope = transient_registration.transient_addresses.site

      return scope.lookup.exists?(uprn: attrs[:uprn].to_s) if attrs[:uprn].present?

      if attrs[:grid_reference].present?
        return scope.auto.exists?(
          grid_reference: attrs[:grid_reference],
          description: attrs[:description]
        )
      end

      scope.where(attrs.slice(:mode, :organisation, :premises, :street_address, :locality, :city, :postcode)).exists?
    end
  end
end
