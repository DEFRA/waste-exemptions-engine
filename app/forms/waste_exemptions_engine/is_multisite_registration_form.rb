# frozen_string_literal: true

module WasteExemptionsEngine
  class IsMultisiteRegistrationForm < BaseForm
    delegate :is_multisite_registration, to: :transient_registration

    validates :is_multisite_registration, "defra_ruby/validators/true_false": true

    def submit(attributes)
      # Single-site and multisite are different application types.
      # Reset site addresses when changing selection to avoid inconsistent state.
      reset_site_addresses

      super
    end

    def minimum_sites_required
      WasteExemptionsEngine::CanHaveMultipleSites.minimum_sites_required
    end

    private

    def reset_site_addresses
      transient_registration.transient_addresses.where(address_type: "site").destroy_all
    end
  end
end
