# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceForm < BaseForm
    include CanClearAddressFinderError

    delegate :site_address, to: :transient_registration

    attr_accessor :grid_reference, :description, :existing_site

    validates :grid_reference, "defra_ruby/validators/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true

    def initialize(transient_registration)
      super
      # Pre-populate from existing site_address for single-site context
      return unless site_address.present? && !transient_registration.multisite?

      self.grid_reference = site_address.grid_reference
      self.description = site_address.description
    end

    def submit(params)
      self.grid_reference = params[:grid_reference]
      self.description = params[:description]

      return false unless valid?

      if multisite_registration?
        return update_existing_site if existing_site.present?

        transient_registration.transient_addresses.create!(
          grid_reference: grid_reference,
          description: description,
          address_type: "site",
          mode: "auto"
        )
        true
      else
        params.merge!(address_type: :site, mode: :auto)
        super(site_address_attributes: params)
      end
    end

    def assign_existing_site(site_address)
      self.existing_site = site_address
      self.grid_reference = site_address.grid_reference
      self.description = site_address.description
    end

    private

    def multisite_registration?
      ActiveModel::Type::Boolean.new.cast(transient_registration.is_multisite_registration)
    end

    def update_existing_site
      existing_site.update!(
        grid_reference: grid_reference,
        description: description
      )
      WasteExemptionsEngine::AssignSiteDetailsService.run(address: existing_site)
      true
    end
  end
end
