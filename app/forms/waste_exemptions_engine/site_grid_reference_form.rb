# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceForm < BaseForm
    delegate :site_address, to: :transient_registration

    attr_accessor :grid_reference, :description

    validates :grid_reference, "defra_ruby/validators/grid_reference": true
    validates :description, "waste_exemptions_engine/site_description": true

    def initialize(transient_registration)
      super
      # Pre-populate from existing site_address for single-site context
      return unless site_address.present? && !transient_registration.multisite_registration?

      self.grid_reference = site_address.grid_reference
      self.description = site_address.description
    end

    def submit(params)
      self.grid_reference = params[:grid_reference]
      self.description = params[:description]

      return false unless valid?

      if transient_registration.multisite_registration?
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
  end
end
