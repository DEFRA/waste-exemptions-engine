# frozen_string_literal: true

require "kaminari"

module WasteExemptionsEngine
  class SitesForm < BaseForm
    def site_addresses(page = nil)
      Kaminari.paginate_array(site_addresses_scope.to_a)
              .page(page_to_display(page))
              .per(sites_per_page)
    end

    def total_sites_count
      site_addresses_scope.count
    end

    def last_page
      [(total_sites_count.to_f / sites_per_page).ceil, 1].max
    end

    def page_to_display(page = nil)
      return last_page if page.blank?

      page.to_i.clamp(1, last_page)
    end

    def can_continue?
      total_sites_count >= minimum_sites_required
    end

    def minimum_sites_required
      WasteExemptionsEngine::CanHaveMultipleSites.minimum_sites_required
    end

    def sites_per_page
      ENV.fetch("MULTISITE_PAGINATION_SIZE", 20).to_i
    end

    private

    def site_addresses_scope
      transient_registration.addresses.where(address_type: "site").order(:id)
    end
  end
end
