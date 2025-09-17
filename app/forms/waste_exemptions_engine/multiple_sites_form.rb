# frozen_string_literal: true

require "kaminari"

module WasteExemptionsEngine
  class MultipleSitesForm < BaseForm
    def site_addresses(page = 1)
      addresses = transient_registration.addresses.where(address_type: "site")
      Kaminari.paginate_array(addresses.to_a)
              .page(page)
              .per(sites_per_page)
    end

    def total_sites_count
      transient_registration.addresses.where(address_type: "site").count
    end

    def can_continue?
      total_sites_count >= minimum_sites_required
    end

    def minimum_sites_required
      ENV.fetch("MULTISITE_MINIMUM_SITES", 30).to_i
    end

    def sites_per_page
      ENV.fetch("MULTISITE_PAGINATION_SIZE", 20).to_i
    end
  end
end
