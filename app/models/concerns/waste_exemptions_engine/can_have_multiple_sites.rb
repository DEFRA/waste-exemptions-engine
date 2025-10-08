# frozen_string_literal: true

module WasteExemptionsEngine
  module CanHaveMultipleSites
    extend ActiveSupport::Concern

    MINIMUM_SITES_DEFAULT = 30

    def self.minimum_sites_required
      ENV.fetch("MULTISITE_MINIMUM_SITES", MINIMUM_SITES_DEFAULT).to_i
    end

    included do
      has_many :site_addresses, -> { site }, class_name: site_address_class_name, dependent: :destroy
    end

    def site_count
      return 1 unless WasteExemptionsEngine::FeatureToggle.active?(:enable_multisite)
      return 1 unless is_multisite_registration

      count = site_addresses.count
      count.zero? ? 1 : count
    end
  end
end
