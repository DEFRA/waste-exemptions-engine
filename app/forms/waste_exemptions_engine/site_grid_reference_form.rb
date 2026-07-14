# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceForm < BaseForm
    include CanClearAddressFinderError
    include CanRestrictSiteLocationsToEngland

    delegate :site_address, :is_linear, :temp_site_id, to: :transient_registration

    attr_accessor :grid_reference, :description

    validates :grid_reference, "defra_ruby/validators/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true
    validate :grid_reference_must_be_in_england, if: :check_grid_reference_location?

    def initialize(transient_registration)
      super
      assign_current_site_values(transient_registration)
    end

    def submit(params)
      params[:grid_reference] = params[:grid_reference]&.strip
      self.grid_reference = params[:grid_reference]
      self.description = params[:description]

      # is_linear apples to the owning transient_registration, not the site address
      transient_registration.update(is_linear: params["is_linear"]) unless params["is_linear"].nil?
      params.delete(:is_linear)

      return false unless valid?

      address_attributes = {
        grid_reference: grid_reference,
        description: description
      }

      SaveSiteAddressService.run(
        transient_registration: transient_registration,
        address_attributes: address_attributes,
        mode: :auto
      )
    end

    private

    def assign_current_site_values(transient_registration)
      site_address = if edit_mode?
                       transient_registration.transient_addresses.find_by(id: temp_site_id)
                     elsif single_site_registration?
                       transient_registration.site_address
                     end

      return unless site_address.present?

      self.grid_reference = site_address.grid_reference
      self.description = site_address.description
    end

    def edit_mode?
      temp_site_id.present?
    end

    def single_site_registration?
      !multisite_registration?
    end

    def multisite_registration?
      @multisite_registration ||= ActiveModel::Type::Boolean
                                  .new.cast(transient_registration.is_multisite_registration)
    end

    def check_grid_reference_location?
      grid_reference.present?
    end

    def grid_reference_must_be_in_england
      return if site_location_allowed?(grid_reference:)

      errors.add(:grid_reference, :outside_england)
    end
  end
end
