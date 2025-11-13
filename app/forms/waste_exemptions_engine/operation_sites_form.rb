# frozen_string_literal: true

require "kaminari"

module WasteExemptionsEngine
  class OperationSitesForm < BaseForm
    def site_addresses(page = 1)
      addresses = transient_registration.transient_addresses.where(address_type: "site").order(:site_suffix)
      Kaminari.paginate_array(addresses.to_a)
              .page(page)
              .per(sites_per_page)
    end

    def total_sites_count
      transient_registration.transient_addresses.where(address_type: "site").count
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

    def site_reference(address)
      if address.site_suffix.present?
        "#{transient_registration.reference}/#{address.site_suffix}"
      else
        transient_registration.reference
      end
    end

    def site_status(address)
      regexemptions = transient_registration.transient_registration_exemptions
      if transient_registration.is_multisite_registration
        regexemptions = regexemptions.where(transient_address: address)
      end

      regexemptions.any? { |re| re.state == "pending" } ? "pending" : "deregistered"
    end

    def ceased_or_revoked_exemptions(address)
      if transient_registration.multisite?
        address.registration_exemptions.where(state: %w[ceased revoked]).map(&:exemption).map(&:code).join(", ")
      else
        transient_registration.registration_exemptions.where(state: %w[ceased
                                                                       revoked]).map(&:exemption).map(&:code).join(", ")
      end
    end
  end
end
