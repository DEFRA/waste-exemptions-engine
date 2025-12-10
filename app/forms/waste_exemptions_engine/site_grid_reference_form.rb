# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceForm < BaseForm
    include CanClearAddressFinderError

    delegate :site_address, :is_linear, :temp_site_id, to: :transient_registration

    attr_accessor :grid_reference, :description

    validates :grid_reference, "defra_ruby/validators/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true

    def initialize(transient_registration)
      super
      # Pre-populate from existing site_address if available
      # For multisite: only pre-populate if editing a specific site (temp_site_id set)
      # For single-site: always pre-populate from site_address
      site_address = if temp_site_id.present?
                       transient_registration.transient_addresses.find_by(id: temp_site_id)
                     elsif !multisite_registration?
                       transient_registration.site_address
                     end

      return unless site_address.present?

      self.grid_reference = site_address.grid_reference
      self.description = site_address.description
    end

    def submit(params)
      self.grid_reference = params[:grid_reference]
      self.description = params[:description]

      # is_linear apples to the owning transient_registration, not the site address
      transient_registration.update(is_linear: params["is_linear"]) unless params["is_linear"].nil?
      params.delete(:is_linear)

      return false unless valid?

      return update_existing_site if temp_site_id.present?

      if multisite_registration?
        transient_registration.transient_addresses.create!(
          grid_reference: grid_reference,
          description: description,
          address_type: "site",
          mode: "auto"
        )
        # Clear temp_site_id so next visit shows empty form for adding another
        transient_registration.update(temp_site_id: nil)
        true
      else
        params.merge!(address_type: :site, mode: :auto)
        super(site_address_attributes: params)
      end
    end

    private

    def multisite_registration?
      ActiveModel::Type::Boolean.new.cast(transient_registration.is_multisite_registration)
    end

    def update_existing_site
      existing_site = transient_registration.transient_addresses.find_by(id: transient_registration.temp_site_id)
      return false unless existing_site.present?

      existing_site.update!(
        grid_reference: grid_reference,
        description: description,
        address_type: "site",
        mode: "auto"
      )

      # Clear temp_site_id so "Add another" shows empty form
      # Edit action will set it again when user clicks edit on a specific site
      transient_registration.update(temp_site_id: nil)

      true
    end
  end
end
