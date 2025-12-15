# frozen_string_literal: true

module WasteExemptionsEngine
  module CanHaveMultipleSites
    extend ActiveSupport::Concern

    MINIMUM_SITES_DEFAULT = 30

    def self.minimum_sites_required
      ENV.fetch("MULTISITE_MINIMUM_SITES", MINIMUM_SITES_DEFAULT).to_i
    end

    included do
      has_many :site_addresses,
               -> { site.order(site_suffix: :asc) },
               class_name: site_address_class_name,
               dependent: :destroy
    end

    def effective_site_count
      # Special case: Assume 1 for a transient registration where the user has indicated
      # not multi-site and has not yet provided the single site address
      return 1 if is_a?(WasteExemptionsEngine::TransientRegistration) && !is_multisite_registration

      site_addresses.count
    end

    def multisite?
      is_multisite_registration || effective_site_count > 1
    end
  end
end
